/**
 * Zotero Journal Abbreviation Updater
 * =====================================
 * Run this script in Zotero via: Tools -> Developer -> Run JavaScript
 *
 * CSV format (header row optional):
 *   The Astrophysical Journal,ApJ
 *   Monthly Notices of the Royal Astronomical Society,MNRAS
 *
 * ---------------------------------------------
 *  USER SETTINGS -- edit these lines only
 * ---------------------------------------------
 */

const CSV_PATH        = "/Users/jhchen/.local/zotero/journal_abbr/journal_abbr.csv";
const LIBRARY_NAME    = "My Library";  // personal or group library name

// To restrict to a specific folder, set its name here.
// Set to "" to process the entire library.
const COLLECTION_NAME = "";

// true  -> skip items that already have a Journal Abbr set
// false -> overwrite existing abbreviations with CSV values
const SKIP_EXISTING   = true;

// true  -> preview only, no changes saved
// false -> apply changes for real
const DRY_RUN         = false;

// ---------------------------------------------
//  Core logic -- no need to edit below here
// ---------------------------------------------

function readLocalFile(path) {
    var file = Components.classes["@mozilla.org/file/local;1"]
                         .createInstance(Components.interfaces.nsIFile);
    file.initWithPath(path);
    if (!file.exists()) throw new Error("File not found: " + path);

    var fis = Components.classes["@mozilla.org/network/file-input-stream;1"]
                        .createInstance(Components.interfaces.nsIFileInputStream);
    fis.init(file, -1, 0, 0);

    var sis = Components.classes["@mozilla.org/scriptableinputstream;1"]
                        .createInstance(Components.interfaces.nsIScriptableInputStream);
    sis.init(fis);

    var content = "";
    var chunk;
    while ((chunk = sis.read(4096)) !== "") { content += chunk; }
    sis.close();
    fis.close();
    return content;
}

// -- Read & parse CSV --
var csvText;
try {
    csvText = readLocalFile(CSV_PATH);
} catch(e) {
    throw new Error("Could not read CSV file:\n  " + CSV_PATH + "\n\n" + e.message);
}

var lookupTable = {};
var csvLineCount = 0;
var csvLines = csvText.split("\n");

for (var i = 0; i < csvLines.length; i++) {
    var line = csvLines[i].trim();
    if (!line) continue;
    if (line[line.length - 1] === "\r") line = line.slice(0, line.length - 1).trim();

    var commaIdx = line.indexOf(",");
    if (commaIdx === -1) continue;

    var fullName = line.slice(0, commaIdx).trim();
    var abbr     = line.slice(commaIdx + 1).trim();

    if (fullName[0] === '"') fullName = fullName.slice(1);
    if (fullName[fullName.length - 1] === '"') fullName = fullName.slice(0, fullName.length - 1);
    if (abbr[0] === '"') abbr = abbr.slice(1);
    if (abbr[abbr.length - 1] === '"') abbr = abbr.slice(0, abbr.length - 1);

    if (!fullName || !abbr) continue;

    var lc = fullName.toLowerCase();
    if (lc === "journal" || lc === "full name" || lc === "full journal name") continue;

    lookupTable[lc] = abbr;
    csvLineCount++;
}

if (csvLineCount === 0) {
    throw new Error("No valid entries found in CSV. Each line should be: Full Journal Name,Abbr");
}

// -- Find target library --
// For group libraries we need the libraryID from Zotero.Groups, not library.id
var allLibs = Zotero.Libraries.getAll();
var library = null;
for (var li = 0; li < allLibs.length; li++) {
    if (allLibs[li].name === LIBRARY_NAME) { library = allLibs[li]; break; }
}

if (!library) {
    var names = allLibs.map(function(l) { return '  - "' + l.name + '" (type=' + l.libraryType + ')'; }).join("\n");
    throw new Error('Library "' + LIBRARY_NAME + '" not found.\n\nAvailable libraries:\n' + names);
}

// Resolve the correct libraryID for collection/item lookups.
// For group libraries, Zotero.Groups stores the real libraryID separately.
var libraryID = library.id;
if (library.libraryType === "group") {
    var allGroups = Zotero.Groups.getAll();
    for (var gi = 0; gi < allGroups.length; gi++) {
        if (allGroups[gi].name === LIBRARY_NAME) {
            libraryID = allGroups[gi].libraryID;
            break;
        }
    }
}

// -- Find collection (folder) if specified --
var scopeLabel = library.libraryType === "group"
    ? 'group library "' + LIBRARY_NAME + '"'
    : 'library "' + LIBRARY_NAME + '"';

var rawItems;

if (COLLECTION_NAME !== "") {
    var allCollections = await Zotero.Collections.getByLibrary(libraryID, true);
    var targetCollection = null;
    for (var ci = 0; ci < allCollections.length; ci++) {
        if (allCollections[ci].name === COLLECTION_NAME) {
            targetCollection = allCollections[ci];
            break;
        }
    }

    if (!targetCollection) {
        var colNames = allCollections.length > 0
            ? allCollections.map(function(c) { return '  - "' + c.name + '"'; }).join("\n")
            : "  (no collections found)";
        throw new Error('Collection "' + COLLECTION_NAME + '" not found in library "' + LIBRARY_NAME + '".\n\nAvailable collections:\n' + colNames);
    }

    rawItems = targetCollection.getChildItems();
    scopeLabel = 'collection "' + COLLECTION_NAME + '" in ' + scopeLabel;
} else {
    rawItems = await Zotero.Items.getAll(libraryID);
}

// -- Filter to items with a publication title --
var journalItems = [];
for (var ii = 0; ii < rawItems.length; ii++) {
    var it = rawItems[ii];
    if (!it.isNote() && !it.isAttachment() && it.getField("publicationTitle", false, true)) {
        journalItems.push(it);
    }
}

// -- Update loop --
var updated      = 0;
var skipped      = 0;
var notFound     = 0;
var notFoundList = [];
var notFoundSeen = {};

for (var ji = 0; ji < journalItems.length; ji++) {
    var item        = journalItems[ji];
    var pubTitle    = item.getField("publicationTitle", false, true).trim();
    var currentAbbr = item.getField("journalAbbreviation", false, true).trim();

    if (SKIP_EXISTING && currentAbbr) { skipped++; continue; }

    var newAbbr = lookupTable[pubTitle.toLowerCase()];

    if (!newAbbr) {
        notFound++;
        if (!notFoundSeen[pubTitle]) { notFoundSeen[pubTitle] = true; notFoundList.push(pubTitle); }
        continue;
    }
    if (newAbbr === currentAbbr) { skipped++; continue; }

    if (!DRY_RUN) {
        item.setField("journalAbbreviation", newAbbr);
        await item.saveTx();
    }
    updated++;
}

// -- Build report --
var mode = DRY_RUN ? "[DRY RUN -- no changes saved]" : "[Changes applied]";
var report = [
    "====================================",
    " Journal Abbreviation Updater " + mode,
    "====================================",
    " Scope        : " + scopeLabel,
    " CSV entries  : " + csvLineCount,
    " Items scanned: " + journalItems.length,
    "------------------------------------",
    " Updated   : " + updated,
    " Skipped   : " + skipped + "  (already had abbr, or already correct)",
    " Not in CSV: " + notFound,
    "====================================",
].join("\n");

if (notFoundList.length > 0) {
    notFoundList.sort();
    report += "\n\nJournals not found in your CSV (consider adding them):";
    for (var ni = 0; ni < notFoundList.length; ni++) {
        report += "\n  - " + notFoundList[ni];
    }
}

return report;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class for notes, designed for astronomic reviews
% Author: Jianhang Chen
% Email: cjhastro@gmail.com
%
% Based on Stylish Article from http://www.LaTeXTemplates.com
%
%
% License:
% CC BY-NC-SA 3.0 (http://creativecommons.org/licenses/by-nc-sa/3.0/)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------------------------------------------
%	CLASS CONFIGURATION
%----------------------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{astronotes/astronotes}[05/03/2021, v1.0]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}} % Pass through any options to the base class
\ProcessOptions\relax % Process given options

\LoadClass{article} % Load the base class

%----------------------------------------------------------------------------------------
%	REQUIRED PACKAGES AND DOCUMENT CONFIGURATIONS
%----------------------------------------------------------------------------------------

\RequirePackage{ifthen}
\RequirePackage{calc}
\RequirePackage{amsmath, amsfonts, amssymb}
\RequirePackage{graphicx}
\graphicspath{{Figures/}{./}} % Specifies where to look for included images (trailing slash required)
\RequirePackage{xcolor}
\RequirePackage{booktabs}
\RequirePackage{lastpage} % Number of pages in the document

\AtEndOfClass{\RequirePackage{microtype}}

\flushbottom % Makes all text pages the same height

%----------------------------------------------------------------------------------------
%	FONTS
%----------------------------------------------------------------------------------------

\RequirePackage[utf8]{inputenc}
\RequirePackage{times} % Loads the Times Roman Fonts
\RequirePackage{mathptmx} % Loads the Times Roman Math Fonts


%----------------------------------------------------------------------------------------
%	COLUMNS
%----------------------------------------------------------------------------------------

\setlength{\columnsep}{0.55cm} % Distance between the two columns of text
\setlength{\fboxrule}{0.75pt} % Width of the border around the abstract


%----------------------------------------------------------------------------------------
%	MARGINS
%----------------------------------------------------------------------------------------

\RequirePackage[
	left=2cm,
	right=2cm,
	top=2.0cm,
	bottom=2.0cm,
	headheight=11pt,
	letterpaper,
]{geometry}

%----------------------------------------------------------------------------------------
%	FIGURE AND TABLE CAPTIONS
%----------------------------------------------------------------------------------------

\RequirePackage[
	labelfont={bf,sf,small},
	labelsep=period,
	justification=raggedright,
]{caption}

\setlength{\abovecaptionskip}{3pt}
\setlength{\belowcaptionskip}{0pt}

%----------------------------------------------------------------------------------------
%	PAGE HEADER
%----------------------------------------------------------------------------------------

\RequirePackage{fancyhdr} % Needed to define custom headers/footers
\pagestyle{fancy} % Enables the custom headers/footers

\renewcommand{\headrulewidth}{0pt} % No header rule
\renewcommand{\footrulewidth}{0pt} % No footer rule

% Headers
\lhead{}
\chead{}
\rhead{\small\sffamily\bfseries\@PaperTitle\ --- \thepage/\pageref{LastPage}}

% Footers
\lfoot{}
\cfoot{}
\rfoot{}

%----------------------------------------------------------------------------------------
%	SECTION SETUP
%----------------------------------------------------------------------------------------

\RequirePackage[explicit]{titlesec}

\titleformat{\section}
	{\color{color1}\large\sffamily\bfseries}
	{}
	{0em}
	{\colorbox{color2!10}{\parbox{\dimexpr\linewidth-2\fboxsep\relax}{\centering\thesection.\space#1}}}
	[]

\titleformat{name=\section,numberless}
	{\color{color1}\large\sffamily\bfseries}
	{}
	{0em}
	{\colorbox{color2!10}{\parbox{\dimexpr\linewidth-2\fboxsep\relax}{\centering#1}}}
	[]

\titleformat{\subsection}
	{\color{color1}\sffamily\bfseries}
	{\thesubsection}
	{0.5em}
	{#1}
	[]

\titleformat{\subsubsection}
	{\sffamily\small\bfseries}
	{\thesubsubsection}
	{0.5em}
	{#1}
	[]

\titleformat{\paragraph}[runin]
	{\sffamily\small\bfseries}
	{}
	{0em}
	{#1} 

\titlespacing*{\section}{0pc}{3ex \@plus4pt \@minus3pt}{5pt}
\titlespacing*{\subsection}{0pc}{2.5ex \@plus3pt \@minus2pt}{0pt}
\titlespacing*{\subsubsection}{0pc}{2ex \@plus2.5pt \@minus1.5pt}{0pt}
\titlespacing*{\paragraph}{0pc}{1.5ex \@plus2pt \@minus1pt}{10pt}

%----------------------------------------------------------------------------------------
%	TABLE OF CONTENTS SETUP
%----------------------------------------------------------------------------------------

\newlength{\tocsep} 
\setlength\tocsep{1.5pc} % Sets the indentation of the sections in the table of contents
\setcounter{tocdepth}{3} % Three levels in the table of contents section: sections, subsections and subsubsections

\usepackage{titletoc}
\contentsmargin{0cm}

\titlecontents{psection}[\tocsep]
  {\addvspace{4pt}\bfseries\sffamily}
  {\contentslabel[\thecontentslabel]{\tocsep}}
  {}
  {\hfill\thecontentspage}
  []

\titlecontents{psubsection}[\tocsep]
  {\addvspace{2pt}\small\sffamily}
  {\contentslabel[\thecontentslabel]{\tocsep}}
  {}
  {\ \titlerule*[.5pc]{.}\ \thecontentspage}
  []

\titlecontents*{psubsubsection}[\tocsep]
  {\footnotesize\sffamily}
  {}
  {}
  {}
  [\ \textbullet\ ]

%----------------------------------------------------------------------------------------
%	MULTIPLE AUTHOR SET
%----------------------------------------------------------------------------------------

\newcount\@authcnt
\newcount\@tmpcnt\@tmpcnt\z@

\def\@affiliation{%
	\ifnum\@tmpcnt<\@authcnt
		 \global\advance\@tmpcnt1
		\raggedright \csname @auth\romannumeral\the\@tmpcnt\endcsname\hfill\\%
		 \let\next\@affiliation \vskip1pt
	\else
		\let\next\relax
	\fi
	\next%
}

\newcommand{\affiliation}[1]{%
	\global\advance\@authcnt1
	\expandafter\gdef\csname @auth\romannumeral\the\@authcnt\endcsname
	{#1}
}

%----------------------------------------------------------------------------------------
%	hyperlinks and colors
%----------------------------------------------------------------------------------------

\definecolor{titlecolor}{RGB}{0,50,100} % Color of the article title
\definecolor{citecolor}{RGB}{200,0,200} % Color of the article title and sections
\definecolor{urlcolor}{RGB}{200,0,200} % Color of the article title and sections
\definecolor{color1}{RGB}{0,0,90} % Color of the article title and sections
\definecolor{color2}{RGB}{0,20,20} % Color of the boxes behind the abstract and headings

\RequirePackage{hyperref}

\hypersetup{
  hidelinks,
  colorlinks,
  breaklinks=true,
  urlcolor=urlcolor,
  citecolor=citecolor,
  linkcolor=color1,
  bookmarksopen=false,
  pdftitle={Title},
  pdfauthor={Author},
}

%----------------------------------------------------------------------------------------
%	LISTS
%----------------------------------------------------------------------------------------

\RequirePackage{enumitem}
%\setlist{nolistsep} % Uncomment to remove spacing before lists (enumerate, itemize)

%----------------------------------------------------------------------------------------
%	ABSTRACT AND AUTHOR FRAME
%----------------------------------------------------------------------------------------

\newcommand{\PaperTitle}[1]{\def\@PaperTitle{#1}}
\newcommand{\Archive}[1]{\def\@Archive{#1}}
\newcommand{\Authors}[1]{\def\@Authors{#1}}
\newcommand{\NoteInfo}[1]{\def\@NoteInfo{#1}}
\newcommand{\Abstract}[1]{\def\@Abstract{#1}}
\newcommand{\Keywords}[1]{\def\@Keywords{#1}}

% ---------------------------------------------------------------------

\renewcommand{\@maketitle}{%
	%\twocolumn[{%
		\thispagestyle{empty}%
		\vskip-36pt%
		{\raggedleft\small\sffamily\bfseries\@NoteInfo\\\@Archive\par}%
		\vskip20pt%
		{\raggedright\color{titlecolor}\sffamily\bfseries\fontsize{20}{25}\selectfont \@PaperTitle\par}%
		\vskip10pt%
		{\raggedright\color{color1}\sffamily\fontsize{12}{16}\selectfont \@Authors\par}%
		\vskip18pt%
		\fcolorbox{color1}{white}{%
			\parbox{\textwidth-2\fboxsep-2\fboxrule}{\centering%
				\colorbox{color2!10}{%
					\parbox{\textwidth-4\fboxsep-2\fboxrule}{%
						\ifx\@Keywords\@empty%
							\sffamily\textbf{\abstractname}\\\@Abstract%
						\else%
							\sffamily\textbf{\abstractname}\\\@Abstract\\[4pt]%
							\textbf{\keywordname}\\\@Keywords%
						\fi%
					}%
				}%
				\vskip4pt%
				\begingroup%
					\raggedright\sffamily\small%
					\footnotesize\@affiliation\par%
				\endgroup%%
			}%
		}%
		\vskip25pt%
	%}]%
}

%----------------------------------------------------------------------------------------
%	REFERENCES
%----------------------------------------------------------------------------------------
\def\thebibliography#1{\section*{REFERENCES}
 \addcontentsline{toc}{section}{REFERENCES}
 % KTS: most of this stuff gets over-written by natbib below, so
 % I don't think it does anything.
 \newcounter{dummy}
 \list{}{\usecounter{dummy}%
         \labelwidth \z@
         \leftmargin 0em %1.5em
		 \bibhang \z@
         \itemsep \z@
         \itemindent-\leftmargin}
 \reset@font\footnotesize
 \parindent\z@
 \parskip\z@ plus .1pt\relax
 \def\newblock{}%\hskip .11em plus .33em minus .07em}
 \sloppy\clubpenalty4000\widowpenalty4000
 \sfcode`\.=1000\relax
}
\let\endthebibliography=\endlist
\def\@biblabel#1{\hspace*{\labelsep}[#1]}

\def\newblock{\hskip .11em plus .33em minus .07em}
\usepackage[authoryear]{natbib}
\bibpunct{(}{)}{;}{a}{}{,}
% Re-define these in upper case as natbib.sty has them capitalised
\renewcommand\bibname{BIBLIOGRAPHY}
\renewcommand\refname{REFERENCES}

% Natbib has overwritten a bunch of settings, so redfine them
% Works both with and without natbib (in theory)
\let\originalbib\thebibliography
\renewcommand{\thebibliography}{\labelwidth \z@ \bibhang 1.5em \footnotesize \originalbib}
%


%----------------------------------------------------------------------------------------
%	Abbreviations
%----------------------------------------------------------------------------------------
% Standard journal abbreviations
% follow normal IAU style.
\newcommand\aap{A\&A}                % Astronomy and Astrophysics
\let\astap=\aap                          % alternative shortcut
\newcommand\aapr{A\&ARv}             % Astronomy and Astrophysics Review (the)
\newcommand\aaps{A\&AS}              % Astronomy and Astrophysics Supplement Series
\newcommand\actaa{Acta Astron.}      % Acta Astronomica
\newcommand\afz{Afz}                 % Astrofizika
\newcommand\aj{AJ}                   % Astronomical Journal (the)
\newcommand\ao{Appl. Opt.}           % Applied Optics
\let\applopt=\ao                         % alternative shortcut
\newcommand\aplett{Astrophys.~Lett.} % Astrophysics Letters
\newcommand\apj{ApJ}                 % Astrophysical Journal
\newcommand\apjl{ApJ}                % Astrophysical Journal, Letters
\let\apjlett=\apjl                       % alternative shortcut
\newcommand\apjs{ApJS}               % Astrophysical Journal, Supplement
\let\apjsupp=\apjs                       % alternative shortcut
% The following journal does not appear to exist! Disabled.
%\newcommand\apspr{Astrophys.~Space~Phys.~Res.} % Astrophysics Space Physics Research
\newcommand\apss{Ap\&SS}             % Astrophysics and Space Science
\newcommand\araa{ARA\&A}             % Annual Review of Astronomy and Astrophysics
\newcommand\arep{Astron. Rep.}       % Astronomy Reports
\newcommand\aspc{ASP Conf. Ser.}     % ASP Conference Series
\newcommand\azh{Azh}                 % Astronomicheskii Zhurnal
\newcommand\baas{BAAS}               % Bulletin of the American Astronomical Society
\newcommand\bac{Bull. Astron. Inst. Czechoslovakia} % Bulletin of the Astronomical Institutes of Czechoslovakia 
\newcommand\bain{Bull. Astron. Inst. Netherlands} % Bulletin Astronomical Institute of the Netherlands
\newcommand\caa{Chinese Astron. Astrophys.} % Chinese Astronomy and Astrophysics
\newcommand\cjaa{Chinese J.~Astron. Astrophys.} % Chinese Journal of Astronomy and Astrophysics
\newcommand\fcp{Fundamentals Cosmic Phys.}  % Fundamentals of Cosmic Physics
\newcommand\gca{Geochimica Cosmochimica Acta}   % Geochimica Cosmochimica Acta
\newcommand\grl{Geophys. Res. Lett.} % Geophysics Research Letters
\newcommand\iaucirc{IAU~Circ.}       % IAU Cirulars
\newcommand\icarus{Icarus}           % Icarus
\newcommand\japa{J.~Astrophys. Astron.} % Journal of Astrophysics and Astronomy
\newcommand\jcap{J.~Cosmology Astropart. Phys.} % Journal of Cosmology and Astroparticle Physics
\newcommand\jcp{J.~Chem.~Phys.}      % Journal of Chemical Physics
\newcommand\jgr{J.~Geophys.~Res.}    % Journal of Geophysics Research
\newcommand\jqsrt{J.~Quant. Spectrosc. Radiative Transfer} % Journal of Quantitiative Spectroscopy and Radiative Transfer
\newcommand\jrasc{J.~R.~Astron. Soc. Canada} % Journal of the RAS of Canada
\newcommand\memras{Mem.~RAS}         % Memoirs of the RAS
\newcommand\memsai{Mem. Soc. Astron. Italiana} % Memoire della Societa Astronomica Italiana
\newcommand\mnassa{MNASSA}           % Monthly Notes of the Astronomical Society of Southern Africa
\newcommand\mnras{MNRAS}             % Monthly Notices of the Royal Astronomical Society
\newcommand\na{New~Astron.}          % New Astronomy
\newcommand\nar{New~Astron.~Rev.}    % New Astronomy Review
\newcommand\nat{Nature}              % Nature
\newcommand\nphysa{Nuclear Phys.~A}  % Nuclear Physics A
\newcommand\pra{Phys. Rev.~A}        % Physical Review A: General Physics
\newcommand\prb{Phys. Rev.~B}        % Physical Review B: Solid State
\newcommand\prc{Phys. Rev.~C}        % Physical Review C
\newcommand\prd{Phys. Rev.~D}        % Physical Review D
\newcommand\pre{Phys. Rev.~E}        % Physical Review E
\newcommand\prl{Phys. Rev.~Lett.}    % Physical Review Letters
\newcommand\pasa{Publ. Astron. Soc. Australia}  % Publications of the Astronomical Society of Australia
\newcommand\pasp{PASP}               % Publications of the Astronomical Society of the Pacific
\newcommand\pasj{PASJ}               % Publications of the Astronomical Society of Japan
\newcommand\physrep{Phys.~Rep.}      % Physics Reports
\newcommand\physscr{Phys.~Scr.}      % Physica Scripta
\newcommand\planss{Planet. Space~Sci.} % Planetary Space Science
\newcommand\procspie{Proc.~SPIE}     % Proceedings of the Society of Photo-Optical Instrumentation Engineers
\newcommand\rmxaa{Rev. Mex. Astron. Astrofis.} % Revista Mexicana de Astronomia y Astrofisica
\newcommand\qjras{QJRAS}             % Quarterly Journal of the RAS
\newcommand\sci{Science}             % Science
\newcommand\skytel{Sky \& Telesc.}   % Sky and Telescope
\newcommand\solphys{Sol.~Phys.}      % Solar Physics
\newcommand\sovast{Soviet~Ast.}      % Soviet Astronomy (aka Astronomy Reports)
\newcommand\ssr{Space Sci. Rev.}     % Space Science Reviews
\newcommand\zap{Z.~Astrophys.}       % Zeitschrift fuer Astrophysik



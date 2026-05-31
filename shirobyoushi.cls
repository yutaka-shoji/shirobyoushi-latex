%% shirobyoushi.cls
%% LaTeX class for SHASE (Society of Heating, Air-Conditioning and
%% Sanitary Engineers of Japan) "Transactions / 論文集" white-cover
%% (白表紙) manuscript.
%%
%% Specification source:
%%   - 執筆要領 (refs/ronbunshippitsuyouryou.pdf, 2014-07-16 論文集委員会決定)
%%   - 版下原稿レイアウト見本 (refs/ronbun_layout.pdf)
%% Target engine: LuaLaTeX.
%%
%% Class options:
%%   blind  -- anonymize: suppress Japanese/English author names,
%%             affiliation footnotes and the acknowledgments block
%%             (for peer review).

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{shirobyoushi}[2026/05/31 SHASE Transactions
white-cover manuscript class]

%% ============================================================
%% Class options
%% ============================================================
\newif\ifshirobyoushi@blind
\shirobyoushi@blindfalse
\DeclareOption{blind}{\shirobyoushi@blindtrue}

%% Forward unknown options to the base class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{jlreq}}
\ProcessOptions\relax

%% ============================================================
%% Base class
%%   論文集: A4, 2-column body, Mincho 9pt, 26 chars x 46 lines/column,
%%   margins top 31mm / bottom 25mm / left=right 17mm (text width 176mm).
%%   Geometry is calibrated against the layout sample; see README.
%% ============================================================
\LoadClass[
  fontsize=9pt,
  a4paper,
  twocolumn,
  jafontscale=1.0,
  line_length=26zw,
  baselineskip=14.9pt,
  head_space=31mm,
  foot_space=25mm,
  column_gap=10mm,
]{jlreq}

%% ============================================================
%% Page style: no header/footer, no page number
%% (folios are added by the editorial office on the 版下)
%% ============================================================
\pagestyle{empty}

%% ============================================================
%% Required packages
%% ============================================================
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{etoolbox}
\RequirePackage{enumitem}
\RequirePackage{booktabs}
\RequirePackage{multicol}

%% Paragraph settings: 1-zenkaku indent, no inter-paragraph space
\setlength{\parindent}{1\zw}
\setlength{\parskip}{0pt}

%% ============================================================
%% Title block: user interface commands
%% ============================================================

% Japanese title (Mincho 18pt, centered, max 2 lines)
\newcommand{\jtitle}[1]{\def\shirobyoushi@jtitle{#1}}
\def\shirobyoushi@jtitle{}

% Japanese serial-report marker, e.g. \jreport{第○報} (Gothic 12pt)
\newcommand{\jreport}[1]{\def\shirobyoushi@jreport{#1}}
\def\shirobyoushi@jreport{}

% Japanese subtitle, e.g. \jsubtitle{和文論文作成例} (Mincho 12pt)
\newcommand{\jsubtitle}[1]{\def\shirobyoushi@jsubtitle{#1}}
\def\shirobyoushi@jsubtitle{}

% English title / report / subtitle
\newcommand{\etitle}[1]{\def\shirobyoushi@etitle{#1}}
\def\shirobyoushi@etitle{}
\newcommand{\ereport}[1]{\def\shirobyoushi@ereport{#1}}
\def\shirobyoushi@ereport{}
\newcommand{\esubtitle}[1]{\def\shirobyoushi@esubtitle{#1}}
\def\shirobyoushi@esubtitle{}

% Japanese abstract (和文概要): Mincho 9pt, 37 chars/line, <= 8 lines
\newcommand{\jabstract}[1]{\def\shirobyoushi@jabstract{#1}}
\def\shirobyoushi@jabstract{}

% English synopsis (英文概要): Roman 9pt, 2-column, <= 550 words
\newcommand{\eabstract}[1]{\def\shirobyoushi@eabstract{#1}}
\def\shirobyoushi@eabstract{}

% Keywords. JA separated by 中黒「・」, EN by comma.
\newcommand{\jkeywords}[1]{\def\shirobyoushi@jkeywords{#1}}
\def\shirobyoushi@jkeywords{}
\newcommand{\ekeywords}[1]{\def\shirobyoushi@ekeywords{#1}}
\def\shirobyoushi@ekeywords{}

% Received date (filled by the editorial office)
\newcommand{\receiveddate}[1]{\def\shirobyoushi@jreceived{#1}}
\def\shirobyoushi@jreceived{}
\newcommand{\ereceiveddate}[1]{\def\shirobyoushi@ereceived{#1}}
\def\shirobyoushi@ereceived{}

%% ------------------------------------------------------------
%% Author / affiliation storage (etoolbox-style csname lists)
%% ------------------------------------------------------------
% \addauthor{ja_name}{en_name}{affil_num}
%   affil_num may be a single number or comma list (e.g. {1} or {1,2}).
\newcounter{shirobyoushi@authorcount}
\setcounter{shirobyoushi@authorcount}{0}
\newcommand{\addauthor}[3]{%
  \stepcounter{shirobyoushi@authorcount}%
  \expandafter\def\csname shirobyoushi@author@\the\c@shirobyoushi@authorcount
  @janame\endcsname{#1}%
  \expandafter\def\csname shirobyoushi@author@\the\c@shirobyoushi@authorcount
  @enname\endcsname{#2}%
  \expandafter\def\csname shirobyoushi@author@\the\c@shirobyoushi@authorcount
  @affilnum\endcsname{#3}%
}

% \addaffiliation{number}{ja_affil}{ja_membership}{en_affil}{en_membership}
\newcounter{shirobyoushi@affilcount}
\setcounter{shirobyoushi@affilcount}{0}
\newcommand{\addaffiliation}[5]{%
  \stepcounter{shirobyoushi@affilcount}%
  \expandafter\def\csname shirobyoushi@affil@#1@jaaffil\endcsname{#2}%
  \expandafter\def\csname shirobyoushi@affil@#1@jamember\endcsname{#3}%
  \expandafter\def\csname shirobyoushi@affil@#1@enaffil\endcsname{#4}%
  \expandafter\def\csname shirobyoushi@affil@#1@enmember\endcsname{#5}%
}

% Field accessors
\newcommand{\shirobyoushi@getauthor}[2]{%
\csname shirobyoushi@author@\the#1@#2\endcsname}
\newcommand{\shirobyoushi@getaffil}[2]{%
\csname shirobyoushi@affil@#1@#2\endcsname}

% Insert footnote text with no leading mark (the content carries its own *N).
\newcommand{\shirobyoushi@plainfootnote}[1]{%
\begingroup\def\@thefnmark{}\@footnotetext{#1}\endgroup}

% Footnote separator rule must span the full column width (jlreq defaults
% it to 1/3 of the line length). \footnoterule references this macro at
% use time, so redefining it here is enough.
\def\jlreq@footnote@rulewidth{\columnwidth}

% Number of Japanese authors per row when 4+ authors (2-column block)
\newcommand{\authorsperrow}[1]{\def\shirobyoushi@authorsperrow{#1}}
\def\shirobyoushi@authorsperrow{2}

%% ------------------------------------------------------------
%% Internal: even spacing (均等割付け) of one CJK block into a fixed
%% width.  Stretchy kanjiskip fills the box so the characters spread
%% evenly, flush at both ends; a lone character (no inter-char glue to
%% stretch) is set flush right, matching the layout sample.
%%   \shirobyoushi@kintou{<width>}{<text>}
%% ------------------------------------------------------------
\newcommand{\shirobyoushi@kintou}[2]{%
  \setbox\@tempboxa=\hbox{#2}%
  \ifdim\wd\@tempboxa<1.5\zw
    \hbox to #1{\hfil#2}%
  \else
    \hbox to #1{\begingroup\ltjsetparameter{kanjiskip={\z@ plus 1fil}}#2\endgroup}%
  \fi
}

%% Split "<surname> <given>" on the first space; sets \shirobyoushi@sur
%% and \shirobyoushi@giv (trailing spaces zapped).  A name with no space
%% yields all-surname and an empty given.
\def\shirobyoushi@splitname#1{\shirobyoushi@splitname@#1 \@nil}
\def\shirobyoushi@splitname@#1 #2\@nil{%
  \def\shirobyoushi@sur{#1}%
  \edef\shirobyoushi@giv{\zap@space#2 \@empty}%
}

%% Common width of one name part (姓 or 名): the widest across all
%% authors.  Every 姓 / 名 block is then 均等割 to this width so the
%% whole list shares one horizontal width.
\newlength{\shirobyoushi@partwidth}
\newcommand{\shirobyoushi@computepartwidth}{%
  \setlength{\shirobyoushi@partwidth}{\z@}%
  \@tempcnta=\z@
  \loop\ifnum\@tempcnta<\value{shirobyoushi@authorcount}%
    \advance\@tempcnta\@ne
    \edef\shirobyoushi@tmpname{\shirobyoushi@getauthor{\@tempcnta}{janame}}%
    \expandafter\shirobyoushi@splitname\expandafter{\shirobyoushi@tmpname}%
    \setbox\@tempboxa=\hbox{\shirobyoushi@sur}%
    \ifdim\wd\@tempboxa>\shirobyoushi@partwidth
      \setlength{\shirobyoushi@partwidth}{\wd\@tempboxa}\fi
    \setbox\@tempboxa=\hbox{\shirobyoushi@giv}%
    \ifdim\wd\@tempboxa>\shirobyoushi@partwidth
      \setlength{\shirobyoushi@partwidth}{\wd\@tempboxa}\fi
  \repeat
}

%% Internal: render one Japanese author
%%   均等割 surname + 1\zw gap + 均等割 given + superscript affiliation.
\newcommand{\shirobyoushi@ja@authorentry}[1]{%
  \edef\shirobyoushi@tmpname{\shirobyoushi@getauthor{#1}{janame}}%
  \expandafter\shirobyoushi@splitname\expandafter{\shirobyoushi@tmpname}%
  % Start a paragraph: the entry opens with assignments (\edef/\setbox)
  % which would otherwise leave the first box stranded in vertical mode.
  \leavevmode
  \shirobyoushi@kintou{\shirobyoushi@partwidth}{\shirobyoushi@sur}%
  \ifx\shirobyoushi@giv\@empty\else
    \hspace{1\zw}\shirobyoushi@kintou{\shirobyoushi@partwidth}{\shirobyoushi@giv}%
  \fi
  \textsuperscript{*\shirobyoushi@getauthor{#1}{affilnum}}%
}

\newcommand{\shirobyoushi@ja@authorblock}{%
  \shirobyoushi@computepartwidth
  \ifnum\value{shirobyoushi@authorcount}>3\relax
  % 4+ authors: 2-column grid
  \newcounter{shirobyoushi@ja@i}\setcounter{shirobyoushi@ja@i}{0}%
  \newcounter{shirobyoushi@ja@col}\setcounter{shirobyoushi@ja@col}{0}%
  \@whilenum\value{shirobyoushi@ja@i}<\value{shirobyoushi@authorcount}\do{%
    \stepcounter{shirobyoushi@ja@i}%
    \stepcounter{shirobyoushi@ja@col}%
    \shirobyoushi@ja@authorentry{\c@shirobyoushi@ja@i}%
    \ifnum\value{shirobyoushi@ja@i}<\value{shirobyoushi@authorcount}%
    \ifnum\value{shirobyoushi@ja@col}=\shirobyoushi@authorsperrow\relax
    \par\setcounter{shirobyoushi@ja@col}{0}\vskip2pt
    \else
    \hspace{2\zw}%
    \fi
    \fi
  }%
  \par
  \else
  % up to 3 authors: single row
  \newcounter{shirobyoushi@ja@j}\setcounter{shirobyoushi@ja@j}{0}%
  \@whilenum\value{shirobyoushi@ja@j}<\value{shirobyoushi@authorcount}\do{%
    \stepcounter{shirobyoushi@ja@j}%
    \shirobyoushi@ja@authorentry{\c@shirobyoushi@ja@j}%
    \ifnum\value{shirobyoushi@ja@j}<\value{shirobyoushi@authorcount}%
    \hspace{2\zw}%
    \fi
  }%
  \par
  \fi
}

%% ------------------------------------------------------------
%% Internal: affiliation footnote (1頁左段下, Mincho 8pt)
%%   *N  和文所属  和文会員資格
%% ------------------------------------------------------------
\newcommand{\shirobyoushi@ja@affilfootnote}{%
  \begingroup
  \fontsize{8pt}{14.9pt}\selectfont
  \newcounter{shirobyoushi@af}\setcounter{shirobyoushi@af}{0}%
  \@whilenum\value{shirobyoushi@af}<\value{shirobyoushi@affilcount}\do{%
    \stepcounter{shirobyoushi@af}%
    \noindent\textsuperscript{*\the\c@shirobyoushi@af}\hspace{0.3em}%
    \shirobyoushi@getaffil{\the\c@shirobyoushi@af}{jaaffil}%
    \hspace{1\zw}%
    \shirobyoushi@getaffil{\the\c@shirobyoushi@af}{jamember}\par
  }%
  \endgroup
}

%% ============================================================
%% \maketitle  (Japanese title block on page 1)
%% ============================================================
\renewcommand{\maketitle}{%
  \twocolumn[%
    \begin{center}%
      %% Japanese title (Mincho 18pt, max 2 lines)
      {
        \vskip 15mm
        \rmfamily\mcfamily\fontsize{18pt}{22pt}\selectfont
        \shirobyoushi@jtitle\par
      }%
      %% Serial report + subtitle (12pt): 第○報 in Gothic, rest in Mincho
      \ifx\shirobyoushi@jreport\@empty
      \ifx\shirobyoushi@jsubtitle\@empty\else
      \vskip 7mm
      {\fontsize{12pt}{16pt}\selectfont\shirobyoushi@jsubtitle\par}%
      \fi
      \else
      \vskip 7mm
      {\fontsize{12pt}{16pt}\selectfont
        {\gtfamily\shirobyoushi@jreport}%
        \ifx\shirobyoushi@jsubtitle\@empty\else
        ―\shirobyoushi@jsubtitle
        \fi
      \par}%
      \fi
      %% Japanese authors (Mincho 11pt)
      \ifshirobyoushi@blind\else
      \vskip 10mm
      {\fontsize{11pt}{15pt}\selectfont
      \shirobyoushi@ja@authorblock}%
      \fi
      %% Japanese abstract (Mincho 9pt, 37 chars/line, centered, <= 8 lines)
      \ifx\shirobyoushi@jabstract\@empty\else
      \vskip 10mm
      {\fontsize{9pt}{13pt}\selectfont
        \begin{minipage}{37\zw}%
          \setlength{\parindent}{1\zw}%
          \shirobyoushi@jabstract\par
      \end{minipage}\par}%
      \fi
      %% Keywords (Gothic 8pt label + Mincho 8pt values)
      \ifx\shirobyoushi@jkeywords\@empty\else
      \vskip 7mm
      {\fontsize{8pt}{12pt}\selectfont
      {\gtfamily キーワード：}\shirobyoushi@jkeywords\par}%
      \fi
    \end{center}%
    \vskip 15mm
  ]% end \twocolumn optional argument
  %% Affiliation footnote at the bottom of the first (left) column.
  \ifshirobyoushi@blind\else
  \shirobyoushi@plainfootnote{\shirobyoushi@ja@affilfootnote}%
  \fi
}

%% ============================================================
%% \makeenglishabstract  (English block on the last page)
%%   Place just before \end{document}, after the references.
%% ============================================================
\newcommand{\shirobyoushi@en@authorline}{%
  by\nobreakspace
  \newcounter{shirobyoushi@en@i}\setcounter{shirobyoushi@en@i}{0}%
  \@whilenum\value{shirobyoushi@en@i}<\value{shirobyoushi@authorcount}\do{%
    \stepcounter{shirobyoushi@en@i}%
    \shirobyoushi@getauthor{\c@shirobyoushi@en@i}{enname}%
    \textsuperscript{*\shirobyoushi@getauthor{\c@shirobyoushi@en@i}{affilnum}}%
    \ifnum\value{shirobyoushi@en@i}<\value{shirobyoushi@authorcount}%
    \ifnum\numexpr\value{shirobyoushi@en@i}+1\relax=\value{shirobyoushi@authorcount}%
    \space and\space
    \else
    ,\space
    \fi
    \fi
  }%
}

\newcommand{\shirobyoushi@en@affilfootnote}{%
  \begingroup
  \fontsize{8pt}{14.9pt}\selectfont
  \newcounter{shirobyoushi@enaf}\setcounter{shirobyoushi@enaf}{0}%
  \@whilenum\value{shirobyoushi@enaf}<\value{shirobyoushi@affilcount}\do{%
    \stepcounter{shirobyoushi@enaf}%
    \hspace*{1\zw}\textsuperscript{*\the\c@shirobyoushi@enaf}\hspace{0.3em}%
    \shirobyoushi@getaffil{\the\c@shirobyoushi@enaf}{enaffil},\space
    \shirobyoushi@getaffil{\the\c@shirobyoushi@enaf}{enmember}\par
  }%
  \endgroup
}

% Width of one body column, for the affiliation note block below.
\newlength{\shirobyoushi@encolwidth}

\newcommand{\makeenglishabstract}{%
  %% Switch to a single-column page: the header spans the full width and
  %% multicol can balance the synopsis (multicols cannot run inside a
  %% twocolumn page). \onecolumn also flushes the references and starts a
  %% fresh page.
  \onecolumn
  \setlength{\shirobyoushi@encolwidth}{\dimexpr(\textwidth-\columnsep)/2\relax}%
  \begin{center}%
    %% English title (Bold 12pt)
    {\rmfamily\bfseries\fontsize{12pt}{16pt}\selectfont
    \shirobyoushi@etitle\par}%
    %% English report / subtitle (Bold 10.5pt)
    \ifx\shirobyoushi@ereport\@empty
    \ifx\shirobyoushi@esubtitle\@empty\else
    \vskip\baselineskip
    {\rmfamily\bfseries\fontsize{10.5pt}{14pt}\selectfont
    \shirobyoushi@esubtitle\par}%
    \fi
    \else
    \vskip\baselineskip
    {\rmfamily\bfseries\fontsize{10.5pt}{14pt}\selectfont
      \shirobyoushi@ereport
      \ifx\shirobyoushi@esubtitle\@empty\else
      \space-\space\shirobyoushi@esubtitle
      \fi
    \par}%
    \fi
    %% English authors (Roman 10.5pt)
    \ifshirobyoushi@blind\else
    \vskip\baselineskip
    {\rmfamily\fontsize{10.5pt}{14pt}\selectfont
    \shirobyoushi@en@authorline\par}%
    \fi
    %% English keywords (Bold 8pt label + Roman 8pt values)
    \ifx\shirobyoushi@ekeywords\@empty\else
    \vskip\baselineskip
    {\rmfamily\fontsize{8pt}{12pt}\selectfont
    {\bfseries Key Words :}\space\shirobyoushi@ekeywords\par}%
    \fi
  \end{center}%
  \vskip\baselineskip
  %% Synopsis (Bold 9pt label + Roman 9pt body), balanced across two
  %% columns. The received date is the last line of the synopsis text,
  %% so it lands at the foot of the right column.
  \ifx\shirobyoushi@eabstract\@empty\else
  \begin{multicols}{2}%
    \rmfamily\fontsize{9pt}{14.9pt}\selectfont
    \noindent{\bfseries Synopsis:}\space\shirobyoushi@eabstract\par
    \ifx\shirobyoushi@ereceived\@empty\else
    {\fontsize{8pt}{14.9pt}\selectfont\par\hfill（\shirobyoushi@ereceived）\par}%
    \fi
  \end{multicols}%
  \fi
  %% English affiliation note: a column-width block with a rule on top,
  %% placed directly below the synopsis at the left column (per the
  %% layout sample) -- not a page-bottom footnote.
  \ifshirobyoushi@blind\else
  \par\noindent
  \parbox[t]{\shirobyoushi@encolwidth}{%
    \kern2pt\hrule\@height\jlreq@omotekeiwidth\kern6pt
    \shirobyoushi@en@affilfootnote
  }\par
  \fi
}

%% ============================================================
%% Section headings
%%   1．ゴシック10.5 (上1行空け) / 1.1 ゴシック / （1）ゴシック9 / a 明朝9
%% ============================================================
\renewcommand{\thesection}{\arabic{section}}
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
\renewcommand{\thesubsubsection}{（\arabic{subsubsection}）}
\renewcommand{\theparagraph}{\alph{paragraph}}

\@addtoreset{subsubsection}{subsection}
\@addtoreset{paragraph}{subsubsection}

% Spacing is given as before_space/after_space (not the fixed `lines`
% gyodori) so a heading that wraps to 2 lines takes its natural height
% instead of overflowing the 1-line slot into the body text. jlreq
% disables the fixed gyodori when both spaces are real dimensions.
\ModifyHeading{section}{
  font={\sffamily\gtfamily\bfseries\fontsize{10.5pt}{14pt}\selectfont},
  label_format={\thesection．},
  after_label_space=0.5\zw,
  before_space={1\baselineskip},
  after_space={0.3\baselineskip},
  indent=0pt
}

\ModifyHeading{subsection}{
  font={\sffamily\gtfamily\bfseries\normalsize},
  after_label_space=0.5\zw,
  before_space=0.0\baselineskip,
  after_space=0.3\baselineskip,
  indent=1\zw,
}

% The full-width opening bracket of （1） is hung at the line head
% (standard Japanese typesetting), so its ink aligns with 1. / 1.1.
% Label （1） in Gothic, heading text in Mincho: `font` is the text font
% (it applies to the whole heading), and the Gothic switch is scoped to
% the label inside label_format (braced so it never leaks to the text).
\ModifyHeading{subsubsection}{
  font={\rmfamily\mcfamily\normalsize},
  label_format={{\sffamily\gtfamily\bfseries\thesubsubsection}},
  after_label_space=0.5\zw,
  before_space=0.0\baselineskip,
  after_space=0.3\baselineskip,
  indent=1\zw
}

% 細目 is a block heading: "a" label (Mincho 9pt) on its own line, body
% on the next line. jlreq defines paragraph as a run-in heading by
% default (which also leaves the counter unstepped, so no "a" prints);
% re-declaring it as a block heading both shows the label and breaks
% after the heading. Indent matches （1） so "a" aligns under it.
\RenewBlockHeading{paragraph}{4}{
  font={\rmfamily\mcfamily\normalsize},
  label_format={{\sffamily\gtfamily\bfseries\theparagraph}},
  after_label_space=1\zw,
  before_space=0.0\baselineskip,
  after_space=0.3\baselineskip,
  second_heading_text_indent={0pt,0pt},
  indent=1\zw
}

% jlreq defaults secnumdepth to 3 (項/subsubsection), which makes the
% level-4 細目 heading unnumbered: its counter is never stepped, so the
% "a" label is empty. Raise it to 4 so 細目 is numbered.
\setcounter{secnumdepth}{4}

%% Unnumbered headings (はじめに / 結論) use \section*.
%% 謝辞 / 付録: Gothic 10.5pt, 5-zenkaku indent, no number, after 結論.
\newcommand{\shirobyoushi@specialheading}[1]{%
  \par\vskip\baselineskip
  {\sffamily\gtfamily\bfseries\fontsize{10.5pt}{14.9pt}\selectfont
  #1\par}%
\vskip0.3\baselineskip\noindent\ignorespaces}

\newcommand{\acknowledgments}{\shirobyoushi@specialheading{謝\hspace{3\zw}辞}}
\newcommand{\acknowledgements}{\acknowledgments}
\let\shirobyoushi@orig@appendix\appendix
\renewcommand{\appendix}{\shirobyoushi@specialheading{付\hspace{3\zw}録}}

%% ============================================================
%% List environments: 1) 2) then a) b) (full-width parens)
%% ============================================================
\setlist[enumerate,1]{label=\arabic*）,leftmargin=1\zw,labelsep=0.2em,nosep,topsep=0pt}
\setlist[enumerate,2]{label=\alph*）,leftmargin=1\zw,labelsep=0.2em,nosep,topsep=0pt}
\setlist[itemize,1]{leftmargin=2\zw,labelsep=0.5em,nosep,topsep=0pt}

%% ============================================================
%% Figure / table captions
%%   図-1 / 表-1 (single dash), caption 8pt, label Gothic 8pt, centered.
%%   図・写真: below; 表: above (LaTeX default placement by user).
%% ============================================================
\renewcommand{\figurename}{図-}
\renewcommand{\tablename}{表-}
\newcommand{\photoname}{写真-}
\renewcommand{\thefigure}{\arabic{figure}}
\renewcommand{\thetable}{\arabic{table}}

\jlreqsetup{
  caption_font={\fontsize{8pt}{11pt}\selectfont},
  caption_label_font={\sffamily\gtfamily\bfseries\fontsize{8pt}{11pt}\selectfont},
  caption_after_label_space=1\zw,
  caption_align=center
}

%% Note / legend helper (8pt, left-aligned).
%% Use under tables and between a figure and its caption.
\newcommand{\figurenote}[1]{%
\par{\fontsize{8pt}{11pt}\selectfont\noindent #1\par}}
\let\tablenote\figurenote

%% ============================================================
%% Citations and references
%%   参考文献: in-text superscript "1)", list label "1)".
%%   見出し「参 考 文 献」Gothic 8pt centered, entries Mincho 8pt.
%% ============================================================
\renewcommand{\refname}{参~考~文~献}
\renewcommand{\@cite}[2]{\textsuperscript{#1)\if@tempswa , #2\fi}}
\renewcommand{\@biblabel}[1]{#1)}

\renewenvironment{thebibliography}[1]{%
\par\vskip\baselineskip
{\centering\sffamily\gtfamily\bfseries\fontsize{8pt}{12pt}\selectfont\refname\par}%
\fontsize{8pt}{12pt}\selectfont
% Disable emphasis so journal names etc. stay upright
\let\em\relax
\let\emph\@firstofone
\let\textit\@firstofone
\list{\arabic{enumiv})}{%
\settowidth\labelwidth{#1)}%
\labelsep=0.5\zw
\leftmargin\labelwidth
\advance\leftmargin\labelsep
\usecounter{enumiv}%
\setlength{\itemsep}{0pt}%
\setlength{\parsep}{0pt}%
}%
\sloppy
\clubpenalty4000
\@clubpenalty\clubpenalty
\widowpenalty4000
\sfcode`\.\@m
}{%
\def\@noitemerr{\@latex@warning{Empty `thebibliography' environment}}%
\endlist
}

%% 引用文献 (direct quotation citation): right-shoulder *N as a footnote.
\renewcommand{\thefootnote}{*\arabic{footnote}}
\newcommand{\quotenote}[1]{\footnote{#1}}

\endinput

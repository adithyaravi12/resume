%% The MIT License (MIT)
%%
%% Copyright (c) 2015 Daniil Belyakov
%%
%% Permission is hereby granted, free of charge, to any person obtaining a copy
%% of this software and associated documentation files (the "Software"), to deal
%% in the Software without restriction, including without limitation the rights
%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%% copies of the Software, and to permit persons to whom the Software is
%% furnished to do so, subject to the following conditions:
%%
%% The above copyright notice and this permission notice shall be included in all
%% copies or substantial portions of the Software.
%%
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%% SOFTWARE.
\ProvidesClass{mcdowellcv}[2015/12/15 v1.1.0 McDowell CV class]

% Set up the fonts according to options
\def\mainfontsize{10pt}
\def\mainfontface{Times New Roman}

\DeclareOption{calibri}{%
  \def\mainfontface{Calibri}
}

\ProcessOptions\relax

% Set font size and paper type
\LoadClass[letterpaper,\mainfontsize]{article} 

% Set document margins
\usepackage[left=0.1in,top=0.3in,right=0.1in,bottom=0.1in]{geometry} 


% Set font face
\usepackage{fontspec}
% \setmainfont[SmallCapsFeatures={Renderer=Basic},
% Ligatures={TeX, NoCommon, NoDiscretionary}]{\mainfontface}
\setmainfont[SmallCapsFeatures={Renderer=Basic},
Ligatures={TeX, NoCommon, NoDiscretionary}, BoldItalicFont=CALIBRIZ.TTF,
    BoldFont      =CALIBRIB.TTF,
    ItalicFont    =CALIBRII.TTF]{CALIBRI.TTF}

% Remove paragraph indentation
\usepackage[parfill]{parskip} 

% Required for boldface (\bf and \bfseries) tabular columns
\usepackage{array} 

% Required for ifthenelse statements
\usepackage{etoolbox} 

% Suppress page numbers
\pagestyle{empty} 

% Flexible tables
\usepackage{tabu}

% For custom margins
\usepackage{changepage}

% To customize lists
\usepackage{enumitem}

% hyperlinks
\usepackage{hyperref}


% Remove left margin from lists, suppress vertical item separation and set top 
% separation to a negative value to suppress a single parskip before lists
\setlist{leftmargin=*, noitemsep, topsep=-1\parskip}

% For spcaed small caps
\usepackage{microtype}

\DeclareMicrotypeSet*{smallcapsi} { 
	encoding = {T1},
	shape    = {sc*,si,scit}
}


%--------------------------------------------------------------------------------
%                                    Constants                                  -
%--------------------------------------------------------------------------------
\def\afterheaderspace{1pt}
\def\beforesectionheaderspace{1pt}
\def\sectionheadermargin{6pt}
\def\aftersectionheaderspace{-4pt}
\def\sectionheaderhrlueheight{0.5pt}
\def\aftersinglelinesubsectionheaderspace{-18.5pt}
\def\afterdoublelinesubsectionheaderspace{-10pt}
\def\aftermultilinesubsectionheaderspace{-6pt}
\def\afteremptysubsectionheaderspace{3pt}
\def\subsectionmargin{5pt}
\def\aftersubsectionspace{4pt}

%--------------------------------------------------------------------------------
%                            Header Setup and Printing                          -
%--------------------------------------------------------------------------------

% Address
\makeatletter

\newcommand\address[1]{\def\@address{#1}}
\address{}

\newcommand\printaddress{
	\small{\@address}
}
% Webpage
\makeatletter
\newcommand\webpage[2][]{\def\@webpage{#2}\def\@webpageurl{#1}}
\address{}

\newcommand\printwebpage{\small{\href{\@webpageurl}{\@webpage}}}
\makeatother

% Name
\makeatletter

\newcommand\name[1]{\def\@name{#1}}
\name{}

\newcommand\printname{
	\textbf{\LARGE{\textsc{\@name}}}
}

\makeatother

% Contacts
\makeatletter
\newcommand\contacts[3]{\def\@phone{#1}\def\@linkedin{#2}\def\@email{#3}}
\contacts{}{}{}

\newcommand\printcontacts{
	\small{\href{tel:\@phone}{\@phone} \linebreak \href{\@linkedin}{LinkedIn Profile} \linebreak \href{mailto:\@email}{\nolinkurl{\@email}}}
}
\makeatother

% GitHub
\makeatletter
\newcommand\github[1]{\def\@github{#1}}
\github{}

\newcommand\printgithub{
	\small{\href{\@github}{GitHub Profile}}
}
\makeatother

\makeatletter
\newcommand\makeheader{
	\begin{center}
		\begin{tabu} to 1\textwidth { X[l,m] X[2,c,m] X[r,m] }
			\printaddress \printwebpage & \printname & \printcontacts \printgithub \\
		\end{tabu}	
	\end{center}
	\vspace*{\afterheaderspace}
}
\makeatother

%--------------------------------------------------------------------------------
%                            Sections and Subsections                           -
%--------------------------------------------------------------------------------

% Print a section header
\makeatletter
\newenvironment{cvsection}[1]{
	\vspace*{\beforesectionheaderspace}
	% Set text margins to equal \tabcolsep (6pt by default)
	\begin{adjustwidth}{\sectionheadermargin}{\sectionheadermargin}
		\textsc{\textbf{#1}}
	\end{adjustwidth}
	\smallskip
	\hrule height \sectionheaderhrlueheight
	\vspace*{\aftersectionheaderspace}
}{}
\makeatother

% Print a subsection
\makeatletter
% Define toggles checking if titles were defined
\newtoggle{lefttitledefined}
\newtoggle{centertitledefined}
\newtoggle{righttitledefined}

\newenvironment{cvsubsection}[4][1]{
	\notblank{#2}{\toggletrue{lefttitledefined}}{}
	\notblank{#3}{\toggletrue{centertitledefined}}{}
	\notblank{#4}{\toggletrue{righttitledefined}}{}
	\ifboolexpr{togl {lefttitledefined} or togl {centertitledefined} or togl {righttitledefined}}{
		\begin{tabu} to 1\textwidth { X[2,l,p] X[c,p] X[r,p] }
			\textbf{#2} & \textbf{#3} & \textbf{#4} \\
		\end{tabu}
		% Add space according to the specidied number of lines
		\ifnumcomp{#1}{=}{1}{\vspace*{\aftersinglelinesubsectionheaderspace}}{
			\ifnumcomp{#1}{=}{2}{\vspace*{\afterdoublelinesubsectionheaderspace}}{
				\vspace*{\aftermultilinesubsectionheaderspace}
			}
		}
	}{
		\vspace*{\afteremptysubsectionheaderspace}
	}
	\togglefalse{lefttitledefined}
	\togglefalse{centertitledefined}
	\togglefalse{righttitledefined}
	\begin{adjustwidth}{\subsectionmargin}{\subsectionmargin}
}
{
	\end{adjustwidth}
	\vspace*{\aftersubsectionspace}
}
\makeatother

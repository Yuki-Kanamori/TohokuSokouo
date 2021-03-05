---
  title: |
  | Chapter 1 
| Nothing as Practical as a Good Theory 
| 良い理論ほど実際に役に立つものはない
subtitle: |
  | in "Fish Ecology, Evolution, and Exploitation: 
    | A Theoretical Synthesis"
| by Ken H. Andersen  
author: |
  | 担当：西嶋 翔太
| （中央水産研究所）
date: "2020-05-11"
# header-includes:
#   \usepackage{luatexja-otf}
#   \hypersetup{unicode=true}
#   \usepackage{luatexja-fontspec}
#   \setmainjfont[BoldFont=HaranoAjiGothic-Bold]{HaranoAjiGothic-Regular}
#   \setsansjfont{HaranoAjiGothic-Medium}
#   \usepackage{setspace}
#   \newcommand{\bdoublespace}{\begin{spacing}{1.5}}
#   \newcommand{\edoublespace}{\end{spacing}{}}
#   \newcommand{\vspacelarge}{\vspace{6mm}}
#   \newcommand{\vspacesmall}{\vspace{3mm}}
output: 
  beamer_presentation:
  latex_engine: lualatex
theme: "default"
colortheme: "seahorse"
fig_caption: false
keep_tex: true
includes:
  in_header: header_config.tex
# mainfont: Meiryo
# monofont: Meiryo
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE,
                      cache= TRUE)
options(tinytex.verbose = TRUE)
```

## 著者について \footnote[frame]{https://ken.haste.dk/} {.smaller}
### Ken H. Andersen 

\begin{columns}
\column{0.30\textwidth}

```{r photo, out.width=100}
setwd("~/git/FishEcoEvo/Chapter1")
knitr::include_graphics("KenAndersen.png")
```

\column{0.70\textwidth}

I want to understand how life in the ocean is organised, why marine organisms look and act the way they do, and how marine ecosystems react to perturbations like  fishing, species removals/invasions or climate change.  

\vspacesmall
More specifically I work on:  
  
  - Trait-based models of life in the ocean  

- Size-structured models of marine ecosystems  

- Fisheries induced  evolution  

\vspacesmall
Previously I have worked with sand ripples under surface waves and barchan dunes in deserts.

\end{columns}

## Google Scholar Citation
<!-- \footnote[frame]{scholar.google.com/citations?user=g1tHbaEAAAAJ&hl=ja} -->
  
  ```{r google_scholar_citation, out.width='105%',fig.align='center'}
knitr::include_graphics("GoogleScholarCitation.png")
```


## この本のレビュー  \footnote[frame]{https://press.princeton.edu/books/hardcover/9780691176550/fish-ecology-evolution-and-exploitation} {.smaller}

\begin{columns}
\column{0.25\textwidth}

```{r about_book, out.width=80}
knitr::include_graphics("FishEcoEvoBook.jpg")
```

\column{0.75\textwidth}

- "Andersen pulls together a cohesive theory from a synthesis of decades of work. He presents a clear and pragmatic foundation for understanding the dynamics at the heart of fisheries and ecology—of individuals, populations, and communities. This leveler will help pave the way for many to tackle the leviathan that is multispecies fisheries."—Beth Fulton\pause

\vspacesmall
- "This book is a fantastic explanation of size- and trait-based analysis of marine ecosystems that should be required reading for marine ecologists and fisheries scientists. Among other results, Andersen provides insights into a community-based approach to ecosystem-based fisheries management."—Ray Hilborn

\end{columns}

---
  
  \begin{LARGE} 
\begin{center}
\begin{bf}
Chapter 1  

Nothing as Practical as a Good Theory
\end{bf}
\end{center}
\end{LARGE}


<!-- ## １章の内容 -->
  
  
  ## 魚の漁業管理の現状
  
  <!-- \bdoublespace -->
  
  - 魚は約1gから100kgまでの体サイズをもち、海の優占的な生物  
\vspacelarge
- 生産性は高く、人々の食糧と富の供給源  
\vspacelarge
- 水産業は世界のたんぱく質の消費量の10％を供給し、その価値は100億ドル (FAO 2016)  
\vspacelarge
- 20世紀半ばに近代トロールの技術が登場して以来、魚類資源の過剰利用が可能になった  
\vspacelarge
- 高い漁獲量を維持するためには、漁業管理が必要である  

<!-- \edoublespace -->
  
  ## Beverton and Holt
  
  
  漁業管理勧告の多くはべバートン・ホルトの枠組みに基づいており、老朽化している

```{r BH, out.width=250,fig.align='center'}
knitr::include_graphics("Fig1.png")
```


## 漁業管理が直面している課題と疑問

- 単一資源管理から生態系アプローチへの拡張  
\vspacelarge
- 漁業による選択の長期的な進化的影響は？  
\vspacelarge
- 生物学的情報が（ほとんど）ない状況、特に開発途上国において、多くの割合を占める「データ不足 (data poor)」な資源をどう管理すべきか？  
\vspacelarge
- 種の多様性が高く、種をほとんど区別しない漁業が実施されており、資源毎の管理が非現実的な多くの生態系をどう扱うべきか？


## 水産資源学と一般生態学

- 手助けやインスピレーションの基となるのは（一般）生態学である  
\vspacelarge
- べバートンとホルトがその枠組みを構築して以来、水産資源学は生態学からは分岐し、管理のための実践的な場面への適用に重きを置くようになった  
\vspacelarge
- 水産資源学は独自の会議や学会を発展させ、プロシーディングスや会議文書といったグレイペーパーや専門的な雑誌で研究発表を行ってきた  
\vspacelarge
- 一方で生態学は、陸水学・食物網生態学・構造のある個体群・進化生態学といった水産資源学にも関連する分野を発展させた 

## 関連分野における生態学の発展 {.smaller}

### 陸水学  
- 多様性が低く、生息地の構造が単純であるため、観察や理解が容易
- 構造をもつ個体群の消費者―資源動態の発展
- 漁業が行われていない海の状態に近い\pause

### 食物網生態学  
- 食物網構造と安定性の関係に着目し、普遍的なパターンを探求
- 漁業などの攪乱への応答は中心的な課題ではなかった\pause  

### 進化生態学
- "Life history invariants"は魚類の観察から生まれた
- 子のサイズ戦略の多様性、繁殖戦略、不定成長の進化は魚類進化の中心的問い
- 魚類の生活史の理解が水産資源学にはあまり応用されていない


## この本の目的

- サイズベース・形質ベースのアプローチを、
魚類の個体群と群集をモデリングするための近代的で一貫した統一的枠組みとして紹介する  
\vspacesmall
- 本理論は生態学と水産資源学の新しい発展から編み出されており、漁業と生態学の問題に幅広く適用可能である  
\vspacesmall
- 長期間放置されてきた、魚類生態学と水産資源学の思考の統一に貢献したい  
\vspacesmall
- ここでは本理論の基本要素を説明するが、古典的な水産資源学に由来する要素から始めて、次に海洋生態学・生理学的に構造化した個体群モデル・形質生態学において発展したサイズベース理論を紹介する


## 方針  {.smaller}

> - 生態系アプローチを漁業管理に適用できるように、べバートン・ホルトの枠組みを修復し、欠けている要素を補うという誘惑に駆られるかもしれない  
<!-- \vspacesmall -->
  <!-- - 2つのバイクを溶接して、エンジンを追加して自動車を作るようなものだ   -->
  <!-- \vspacesmall -->
  > - べバートン・ホルトの修復では、
<!-- 私が追い求める -->厳密な理論は構築できない(2つのバイクを溶接して自動車を作るようなものだ！)  
<!-- \vspacesmall -->
  > - 漁業の勧告のような実践的な応用は、確固とした理論的・基礎的理解に基づくのがベストであるはず
（この本のタイトルにある名言を作ったKurt Lewinと同様に）  
<!-- \vspacesmall -->
  > - Von Bertalanffyの成長式・スプレッドシートに適した生命表・親魚の死亡率$M$の概念を捨て,その代わりに生理学・微分方程式・サイズ依存の死亡率を使用する  
<!-- \vspacesmall -->
  > - 本理論は、Hilborn & Walters (1992) やQuinn & Deriso (1999)といった古典に精通している人には取っつきにくく、複雑に感じるかもしれない  
<!-- \vspacesmall -->
  > - 少ない仮定のみで、単一種の影響評価から進化率の推定や生態系の影響評価まで行えることが本理論の利点である
## 多種系およびサイズベースのアプローチ  {.smaller}

<!-- \vspacesmall -->
  > - Andersen(著者とは別人)とUrsinは1970年代に、「一次・二次生産から栄養塩循環、餌へのサイズ依存の選択性に至るまでのあらゆることは、魚1個体の生理的な描写に基づいている」という重要で新しい考えを紹介した
（が、数式の複雑さや無名の雑誌で公表したことが原因で忘れ去られた）  
<!-- \vspacesmall -->
  > - 著者の理論は、Kleiberの法則と呼ばれる体サイズによる代謝作用のスケーリングと「大きい魚はより小さい魚を食べる」という法則に基づく
<!-- \vspacesmall -->
  > - この2つの法則は体サイズの分布を説明する (Sheldon et al. 1977)
<!-- \vspacesmall -->
  <!-- - Brown et al. (2004) の代謝理論よりもよりも、著者は特に死亡率に対して、より強力な基盤を提供する   -->
  <!-- \vspacesmall -->
  > - 著者は群集だけでなく個体群内のサイズ分布も予測する
<!-- \vspacesmall -->
  > - WernerとGilliam (1984) は年齢ベースのべバートン・ホルト理論では
異なるステージ間の競争や捕食を表すことができないと指摘し、
体サイズに基づく理論的枠組みの草案を書いた  
<!-- \vspacesmall -->
  > - PerssonとDe Roos (2013) 
は生理学的に構造のある個体群における密度依存的なボトルネックに関する膨大な解析を行った  

## 植物と魚の類似点

- 植物と魚類は①（多くの場合で）小さい子を生む、②（多くの場合で）子育てを行わない、③成熟後も成長を続ける、という点で似ている  
\vspacelarge
- 植物生態学者は形態ベースのアプローチを発展させ、無数の種からなる複雑な群集に取り組んでいる  
\vspacelarge
- 種が漁業管理と生物学の格である状況において、形質ベースアプローチは議論の的である
\vspacelarge
- 個体群レベルの理論の多くが特定の種に対してきちんと適用できる


## 形質ベースアプローチ

> - 著者の形質ベースアプローチはJohn Popeら (2006) の研究から着想を得た  
<!-- \vspacesmall -->
  > - 全ての種のあるパラメータを、各々の種の最大体長の平均と関連付ける
<!-- \vspacesmall -->
  > - 漸近（最大）体サイズがマスタートレイトである
<!-- \vspacesmall -->
  > - 他の形質も含めて一般化することは可能だが、少ない形質で種を特徴づけられると考えているため、
形質の追加は慎重に行うべきである  
<!-- \vspacesmall -->
  > - 形質ベースアプローチは、多くの種が相互作用する食物網の複雑さを回避できるため、
魚類群集全体の動的理論の開発に重要である  
<!-- \vspacesmall -->
  > - ある資源の知見が少なくても、水揚げされた個体の最大サイズについては分かっていることは多く、形質ベースアプローチは、理論をデータ不足下と関連付けるための隠し味である  
<!-- \vspacesmall -->
  > - 現実の生態系は種から構成されており、
実践的な漁業管理は個々の資源に注意を払わなくてはいけない

---
  
  \begin{LARGE} 
\begin{center}
\begin{bf}
1.1   

What Charactarizes a Good Theory?
  \end{bf}
\end{center}
\end{LARGE}

## 良い理論とはカードゲームのようなものだ

- カードゲームは少なくて単純なルールから、複雑で楽しいゲームを提供する  
\vspacelarge
- 理論も少ない基礎的な原理に基づく
\vspacelarge
- 原理は広く受け入れられ、確固とした証拠や他の理論との関連をもつ必要がある  
\vspacelarge
- よい理論とは定性・定量の両面において重要な予測を導く（最大漁獲を実現する漁獲圧があるということだけでなく、その水準も予測できるのが良い理論）


## 生態学において実験は困難である {.smaller}

- 生態学において理想的な条件下で実験が行われるのは、せいぜい個体の生理に関するものくらいである（機能の反応、遊泳速度、代謝率など）\pause  
\vspacesmall
- 海では非意図的な実験を実行  
1. 半世紀以上にわたる大スケールでの漁業の実施によって海の群集がどう変わるか？  
1. 資源の除去に対して海洋生態系がどう応答するか？\pause

\vspacesmall
- 地球科学や天文学でも実験は困難であるが、ニュートンの法則やシュレディンガー方程式といった確固とした基盤がある\pause    
\vspacesmall
- 生態学では、そういった大前提は少なく、有効性も限定的\pause    
\vspacesmall
- 海の魚の実験や直接観察は困難であるため、モデルは特別な価値をもつ\pause    
\vspacesmall
- モデルをチェックするための直接観察ができないので、信用できるモデルの基礎的な前提を置くことの重要性は高い  

---
  
  \begin{LARGE} 
\begin{center}
\begin{bf}
1.2   

How to Read This Book
\end{bf}
\end{center}
\end{LARGE}


## 本の構成
### 4つのパートからなる

1. Individuals: 個体レベルの生物現象に関する大前提  
- 2章: サイズスペクトル理論
- 3章: 個体の成長と繁殖\pause

1. Populations: 個体群統計学と単一種管理  
- 4章: 個体群統計学
- 5章: 漁獲
- 6章: 漁業による進化
- 7章: 個体群動態\pause

1. Traits: 進化生態学や生活史理論との関連付け
- 8章: 「真骨魚類」vs.「軟骨魚類」
- 9章: 魚類生態学の形質ベースアプローチ\pause

1. Communities: ひとつの個体群から群集全体への拡張  
- 10章: 消費者―資源動態
- 11章: 魚類群集の形質構造
- 12章: 漁獲の群集影響
- 13章: チャンスとチャレンジ


## 各章の位置づけ

```{r Fig2, out.width=225,fig.align='center'}
knitr::include_graphics("Fig2.png")
```


## この本を読むにあたって

- 著者が25以上の雑誌に発表した10年以上の成果の集大成である  
\vspacesmall
- 数式に馴れていない読者のために、概念や原理、結果の説明に重きを置いた  
\vspacesmall
- 複雑な数式の導出はBoxに示し、Boxを飛ばしても読めるようになっている  
\vspacesmall
- 図の生成のためのコードはRで書かれており、Web上で公開されている  \footnote[frame]{https://github.com/Kenhasteandersen/Fish}  
\vspacesmall
- 始めから最後まで順番に読む必要はない  
\vspacesmall
- 少なくとも2章の最初の部分を読んで理論の基本となる前提を理解し、可能であれば3章も合わせて読むことを推奨する

<!-- \footnotetext{本文で示されているリンクは見つからない} -->
# shirobyoushi-latex

**［非公式］空気調和・衛生工学会論文集（通称「白表紙」）LaTeX テンプレート**

空気調和・衛生工学会（SHASE）論文集の完全版下原稿（和文）を作成するための、非公式の LaTeX ドキュメントクラスとサンプル原稿です。学会の「執筆要綱」および「版下原稿レイアウト見本」に基づき、レイアウトを再現します。

> **注意**　本リポジトリは個人が作成した非公式のものであり、空気調和・衛生工学会が公式に配布・保証するものではありません。最終的な体裁は必ず学会の最新の「執筆要綱」「レイアウト見本」とご自身で照合してください。

---

## 動作環境

| 項目                       | 内容                                                                                                                                   |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| TeX ディストリビューション | **TeX Live 2023 以降**（または MacTeX）を推奨                                                                                          |
| 組版エンジン               | **LuaLaTeX**（`lualatex`）。pLaTeX ではありません                                                                                      |
| 文献処理                   | `upbibtex` + `junsrt.bst`（TeX Live に同梱）                                                                                           |
| 必須パッケージ             | `jlreq` / `luatexja-fontspec` / `bxjalipsum` / `unicode-math` / `siunitx` / `booktabs` / `multirow` ほか（いずれも TeX Live 標準収録） |

### フォントについて

サンプル `manuscript.tex` は 学会テンプレートが使用している **MS 明朝・MS ゴシック**、欧文 **Times New Roman**と、数式には **STIX Two Math** を指定しています。これらのフォントが入っていない環境（macOS / Linux など）では、`manuscript.tex` 冒頭のフォント指定を手元のフォントに置き換えてください（[FAQ](#よくあるつまずきfaq) 参照）。

### 任意のツール（lint・整形・差分に使用）

`make lint` などを使う場合のみ必要です。なくてもビルドはできます。

- [`chktex`](https://www.nongnu.org/chktex/)（TeX Live 同梱）… LaTeX の文法チェック
- [`typos`](https://github.com/crate-ci/typos) … スペルチェック
- [`tex-fmt`](https://github.com/WGUNDERWOOD/tex-fmt) … `.tex` の自動整形
- `latexdiff-vc`（TeX Live 同梱）… 改訂差分 PDF の生成

---

## ディレクトリ構成

```
shirobyoushi-latex/
├── shirobyoushi.cls    ドキュメントクラス本体（レイアウト定義）
├── manuscript.tex      サンプル原稿（これを編集して使う）
├── manuscript.pdf      サンプル原稿の組版結果（仕上がりイメージの確認用）
├── references.bib      参考文献データベース（BibTeX 形式）
├── .latexmkrc          latexmk 設定（LuaLaTeX・出力先 out/ を指定）
├── Makefile            ビルド／lint／整形／差分のタスク定義
├── LICENSE             MIT ライセンス
├── README.md           このファイル
└── out/                ビルド成果物（manuscript.pdf など）※自動生成
```

`out/` は `latexmk` が自動生成する出力ディレクトリです。中間ファイルと完成 PDF（`out/manuscript.pdf`）が入ります。Git では追跡されません。

---

## 使い方（LaTeX 入門者向け）

LaTeX を初めて使う方向けに、PDF が出るまでの手順を順を追って説明します。

### 1. TeX 環境を用意する

PC に TeX Live（macOS なら MacTeX）が入っていなければインストールします。LuaLaTeX と必要なパッケージがまとめて入る **フルインストール** を推奨します。

- **Windows / Linux**: [TeX Live](https://www.tug.org/texlive/)
- **macOS**: [MacTeX](https://www.tug.org/mactex/)

インストール後、ターミナル（コマンドプロンプト）で次を実行し、バージョンが表示されれば準備完了です。

```bash
lualatex --version
latexmk --version
```

### 2. リポジトリを入手する

```bash
git clone <このリポジトリのURL>
cd shirobyoushi-latex
```

（Git を使わない場合は、ZIP でダウンロードして展開しても構いません。）

### 3. サンプルをビルドして PDF を作る

まずは付属のサンプルがそのままビルドできるか確かめます。リポジトリの直下で次を実行してください。

```bash
latexmk
```

`.latexmkrc` に設定が書いてあるため、引数なしの `latexmk` だけで「LuaLaTeX で組版 → `upbibtex` で文献処理 → 必要回数だけ再組版」までを自動で行います。成功すると **`out/manuscript.pdf`** が生成されます。

なお、仕上がりの参考用に、リポジトリ直下に組版済みのサンプル **`manuscript.pdf`** を同梱しています。まずはこの PDF でレイアウトを確認できます。

`make` が使える環境であれば、同じことを次のように書けます。

```bash
make          # = make pdf. out/manuscript.pdf を生成
```

> **ポイント** 本テンプレートは **LuaLaTeX 専用** です。エディタ（VS Code + LaTeX Workshop、TeXShop など）からビルドする場合も、エンジンを `lualatex`、ビルドツールを `latexmk` に設定してください。リポジトリ同梱の `.latexmkrc` が自動的に使われます。

### 4. 自分の原稿に書き換える

`manuscript.tex` を開き、サンプルの内容を自分の論文に置き換えていきます。編集する主な箇所は次のとおりです。

1. **タイトル・著者・概要などのメタ情報**（プリアンブル部分）
   `\jtitle{...}` `\addauthor{...}{...}{...}` `\jabstract{...}` などのコマンドの中身を書き換えます。各コマンドの意味は [テンプレートのコマンド一覧](#テンプレートのコマンド一覧) を参照してください。

2. **本文**（`\begin{document}` から `\end{document}` の間）
   `\section{...}` などの見出しと段落を、自分の論文の内容に置き換えます。

3. **参考文献**（`references.bib`）
   引用する文献を BibTeX 形式で記述します。サンプルのエントリを参考に書き換えてください。本文中で `\cite{ref1}` のように引用すると、肩付きで `1)` と表示されます。サンプルでは `\nocite{*}` により `.bib` に書いた順で全件を出力しています。

編集したら、再度 `latexmk`（または `make`）を実行して PDF を更新します。

#### 査読版（著者匿名）を作るには

査読用に著者名・所属・謝辞を伏せたい場合は、`manuscript.tex` の 1 行目を次のように `blind` オプション付きに変更します。

```latex
\documentclass[blind]{shirobyoushi}
```

---

## テンプレートのコマンド一覧

`manuscript.tex` のプリアンブルで使う、本クラス独自のコマンドです。

### タイトルブロック（和文）

| コマンド          | 説明                                                           |
| ----------------- | -------------------------------------------------------------- |
| `\jtitle{...}`    | 和文タイトル（18pt・中央・最大 2 行）。改行は `\\`             |
| `\jreport{...}`   | 連報表記（例 `第1報`）。連報でなければ `\jreport{}` と空にする |
| `\jsubtitle{...}` | 和文副題                                                       |
| `\jabstract{...}` | 和文概要（9pt・37 字詰・8 行以内・300 字程度）                 |
| `\jkeywords{...}` | 和文キーワード（中黒「・」区切り、手法 KW を先頭に）           |

### タイトルブロック（英文・最終ページ）

| コマンド              | 説明                                                   |
| --------------------- | ------------------------------------------------------ |
| `\etitle{...}`        | 英文タイトル                                           |
| `\ereport{...}`       | 英文の連報表記（例 `Part 1`）                          |
| `\esubtitle{...}`     | 英文副題                                               |
| `\eabstract{...}`     | 英文概要（Synopsis、9pt・2 段・550 語以内）            |
| `\ekeywords{...}`     | 英文キーワード（カンマ区切り）                         |
| `\ereceiveddate{...}` | 受理日（事務局が記入。例 `Received October 30, 1998`） |

### 著者・所属

```latex
% 著者: \addauthor{和文氏名}{英文氏名}{所属番号}
\addauthor{空調 太郎}{Taro KUCHO}{1}

% 所属: \addaffiliation{番号}{和文所属}{和文資格}{英文所属}{英文資格}
\addaffiliation{1}{空調工業（株）設備部}{特別会員}%
  {Engineering Division, Kucho Industry Co., Ltd.}{Fellow Member}
```

- 和文氏名は「姓 名」の間に **半角スペース** を入れます（均等割付けの基準になります）。
- 所属番号はカンマ区切りで複数指定できます（例 `{1,2}`）。
- 著者が 4 名以上の場合は自動で 2 列に組まれます（`\authorsperrow{n}` で 1 行あたりの人数を変更可）。

### 本文・図表・引用

| コマンド                               | 説明                                                          |
| -------------------------------------- | ------------------------------------------------------------- |
| `\section{...}` 〜 `\paragraph{...}`   | 章・節・項・細目の見出し（`1．` `1.1` `（1）` `a` の 4 階層） |
| `\section*{...}`                       | 章番号なしの見出し（「はじめに」「結論」用）                  |
| `\acknowledgments`                     | 「謝辞」見出し（章番号なし）                                  |
| `\appendix`                            | 「付録」見出し（章番号なし）                                  |
| `\caption{...}` / `\label{...}`        | 図表のタイトル（`図-1` `表-1`）と参照ラベル                   |
| `\figurenote{...}` / `\tablenote{...}` | 図・表の注や凡例（8pt・左詰め）                               |
| `\quotenote{...}`                      | 本文中の脚注（右肩 `*1`）                                     |
| `\makeenglishabstract`                 | 英文概要ブロックを出力（`\end{document}` の直前に置く）       |

> 図表を両段（通し）幅にするときは `table*` / `figure*` 環境を使います（サンプルの表を参照）。

---

## Makefile タスク一覧

`make` が使える環境では、以下のタスクが利用できます（`make help` でも確認できます）。

| コマンド             | 説明                                         |
| -------------------- | -------------------------------------------- |
| `make` / `make pdf`  | PDF をビルド（`out/manuscript.pdf`）         |
| `make lint`          | `chktex` と `typos` でチェック               |
| `make check`         | `tex-fmt --check` で整形崩れを確認           |
| `make format`        | `tex-fmt` で `.tex` を自動整形               |
| `make diff TAG=v1.0` | 指定の Git タグ／コミットとの差分 PDF を生成 |
| `make clean`         | 中間ファイルを削除                           |
| `make cleanall`      | 生成物をすべて削除                           |

`make diff` は改訂時に便利で、過去のバージョンからの変更箇所を色付きで示した PDF（`latexdiff`）を作成します。

---

## フォントの確認・変更

LuaLaTeX のフォント指定（`\setmainjfont` など）には、OS にインストール済みのフォントの **ファミリー名** をそのまま書けます。手元でどんな名前のフォントが使えるかは、TeX Live 付属の `luaotfload-tool` で調べられます。

### 使えるフォントを探す

```bash
# 名前に "mincho" を含むフォントを一覧（大文字小文字を区別しない）
luaotfload-tool --list="*" | grep -i mincho

# ヒラギノ系を探す
luaotfload-tool --list="*" | grep -i hiragino
```

表示された左列の名前を、`manuscript.tex` の `\setmainjfont{...}` などにそのまま指定します。例えば上の検索で見つかる原ノ味明朝なら `\setmainjfont{Harano Aji Mincho}` のように書きます。日本語名のフォント（例 `ヒラギノ明朝 ProN`）も指定できます。

### フォントを追加・更新したらキャッシュを再構築する

OS に新しいフォントをインストールしたのに `luaotfload-tool --list` で見つからない、あるいはビルド時に「フォントが見つからない」と言われる場合は、フォント情報のキャッシュ（データベース）を作り直します。

```bash
luaotfload-tool --update          # 変更分だけ更新
luaotfload-tool --update --force  # データベースを完全に再構築
```

### Windows / WSL で Windows 側のフォント（MS 明朝など）を使う

WSL（Windows Subsystem for Linux）上の TeX Live から、Windows にインストールされている MS 明朝・MS ゴシックなどを利用できます。Windows のフォントフォルダ `C:\Windows\Fonts`（WSL からは `/mnt/c/Windows/Fonts`）を、`luaotfload` の検索パスに加えてキャッシュを再構築します。

```bash
# 現在のシェルだけで有効にする場合
export OSFONTDIR=/mnt/c/Windows/Fonts
luaotfload-tool --update --force

# 恒久的に有効にするには ~/.bashrc などに追記
echo 'export OSFONTDIR=/mnt/c/Windows/Fonts//' >> ~/.bashrc
```

`OSFONTDIR` は LuaTeX が参照する追加フォント検索パスの環境変数です。設定後に `luaotfload-tool --find="MS Mincho"` で見つかれば、サンプルのフォント指定（MS 明朝・MS ゴシック・Times New Roman）をそのままビルドできます。

> 素の Windows（WSL ではなくネイティブの TeX Live）では `C:\Windows\Fonts` のフォントは標準で検索対象に含まれるため、通常この設定は不要です。

---

## よくあるつまずき（FAQ）

**Q. ビルドで `Font ... not found` のようなエラーが出る**
A. サンプルは Windows 標準フォント（MS 明朝・MS ゴシック・Times New Roman）を指定しています。これらが無い環境では `manuscript.tex` の冒頭部分

```latex
\setmainfont{Times New Roman}
\setsansfont[BoldFont={MS Gothic}]{MS Gothic}
\setmainjfont[BoldFont={MS Mincho}]{MS Mincho}
\setsansjfont[BoldFont={MS Gothic}]{MS Gothic}
```

を、手元にあるフォントへ書き換えてください。例えば macOS なら `ヒラギノ明朝 ProN` / `ヒラギノ角ゴシック`、TeX Live 同梱フォントを使うなら原ノ味フォント（`Harano Aji Mincho` / `Harano Aji Gothic`）などが利用できます。使えるフォント名の調べ方や、WSL で Windows 側のフォントを使う方法は [フォントの確認・変更](#フォントの確認変更) を参照してください。

**Q. `pdflatex` や `platex` でビルドできない**
A. 本テンプレートは **LuaLaTeX 専用** です。`latexmk`（同梱の `.latexmkrc` が `lualatex` を使う設定）でビルドしてください。

**Q. 参考文献が出力されない / `?` になる**
A. `latexmk` は文献処理（`upbibtex`）を含めて自動実行します。エディタから単発で `lualatex` だけを回している場合は反映されません。`latexmk`（または `make`）でビルドしてください。

**Q. `make` コマンドが無い（Windows）**
A. `make` は必須ではありません。`latexmk` を直接実行すれば PDF は生成できます。

---

## ライセンス

[MIT License](LICENSE) © 2026 Shoji, Yutaka

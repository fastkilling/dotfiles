""" release autogroup in MyAutoCmd
augroup MyAutoCmd
    autocmd!
augroup END

""" 表示関係
"ウインドウサイズの指定
set columns=120
set lines=40
set t_Co=256
set background=dark
syntax on
set list                " 不可視文字の可視化
set number              " 行番号の表示
set ruler               " カーソル位置が右下に表示される
set wildmenu            " コマンドライン補完が強力になる
set showcmd             " コマンドを画面の最下部に表示する
set wrap                " 長いテキストの折り返し
set textwidth=0         " 自動的に改行が入るのを無効化
"set colorcolumn=80     " その代わり80文字目にラインを入れる
set cursorline          " カーソル行の背景色を変える
set cursorcolumn        " カーソル列の背景色を変える
" 前時代的スクリーンベルを無効化
set t_vb=
set novisualbell
set foldmethod=indent    " 折り畳み
set foldlevel=100    " ファイルを開くときに折り畳みをしない

""" 編集関係
set infercase           " 補完時に大文字小文字を区別しない
set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
if has('persistent_undo')
    if !isdirectory('~/.vim/undo')
        call system('mkdir ~/.vim/undo')
        set undodir=~/.vim/undo
        set undofile
    endif
endif
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする
set autoindent          " 改行時にインデントを引き継いで改行する
set shiftwidth=4        " インデントにつかわれる空白の数
au BufNewFile,BufRead *.yml set shiftwidth=2
set softtabstop=4       " <Tab>押下時の空白数
set expandtab           " <Tab>押下時に<Tab>ではなく、ホワイトスペースを挿入する
set tabstop=4           " <Tab>が対応する空白の数
au BufNewFile,BufRead *.yml set tabstop=2
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set nf=                 " インクリメント、デクリメントを10進数にする
" 対応括弧に'<'と'>'のペアを追加
set matchpairs& matchpairs+=<:>
" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start
" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在しているかどうかで設定を分ける必要がある
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus,unnamed
else
    set clipboard& clipboard+=unnamed
endif
" Swapファイル, Backupファイルを全て無効化する
set nowritebackup
set nobackup
set noswapfile

""" 検索関係
set ignorecase          " 大文字小文字を区別しない
set smartcase           " 検索文字に大文字がある場合は大文字小文字を区別
set incsearch           " インクリメンタルサーチ
set hlsearch            " 検索マッチテキストをハイライト
" バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

""" マクロおよびキー設定
" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>
" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk
" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %
" [ と打ったら [] って入力されてしかも括弧の中にいる(以下同様)
inoremap [ []<left>
inoremap ( ()<left>
inoremap { {}<left>
inoremap " ""<left>
au BufNewFile,BufRead *.vimrc inoremap " "
inoremap ' ''<left>
" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>
" タブ間の移動
nnoremap <C-n> gt
nnoremap <C-p> gT
" Ctrl + e でNerdTree起動
map <C-e> :NERDTreeToggle<CR>
"nnoremap <silent><C-e> :NERDTreeToggle<CR>
" :e などでファイルを開く際にフォルダが存在しない場合は自動作成
function! s:mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)
" vim 起動時のみカレントディレクトリを開いたファイルの親ディレクトリに指定
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif
    if a:bang == ''
        pwd
    endif
endfunction
autocmd MyAutoCmd VimEnter * call s:ChangeCurrentDir('', '')

" *******************************************************
" dein Scripts
" *******************************************************
if &compatible
  set nocompatible
endif
 " dein自体の自動インストール
let s:cache_home = expand('~/.vim')
"let s:dein_dir = s:cache_home . '/dein'
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
"if dein#load_state(s:dein_cache_repo_dir)
if dein#load_state(s:dein_dir)
    "required
    call dein#begin(s:dein_dir)

    " Add or remove your plugins here"
    call dein#add('Shougo/dein.vim')

    " プラグインリストを収めた TOML ファイル
    " プラグイン読み込み＆キャッシュ作成
    let s:toml = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
    let s:toml_lazy = fnamemodify(expand('<sfile>'), ':h').'/dein_lazy.toml'
    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:toml_lazy, {'lazy': 1})

    "required
    call dein#end()
    call dein#save_state()
endif
filetype plugin indent on
syntax enable
" 不足プラグインの自動インストール
"if has('vim_starting') && dein#check_install()
""  call dein#install()
""endif
" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
" *******************************************************
" End dein Scripts
" *******************************************************
"colorscheme molokai

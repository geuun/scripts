set rtp+=~/.vim/bundle/Vundle.vim

"--------------------------------------------Plugin 시작

call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'airblade/vim-gitgutter' " vim with git status(added, modified, and removed lines)
Plugin 'tpope/vim-fugitive' " vim with git command(e.g., Gdiff)
Plugin 'vim-airline/vim-airline' " vim status bar
Plugin 'vim-airline/vim-airline-themes'
Plugin 'blueyed/vim-diminactive'
Plugin 'hynek/vim-python-pep8-indent'   " python 자동 들여쓰기 Plugin
Plugin 'nvie/vim-flake8'                " python 문법 검사 plugin
Plugin 'AutoComplPop' 					" Vim에서 자동완성 기능(Ctrl + P)을 키입력하지 않더라도 자동으로 나타나게

call vundle#end()

set t_Co=256

"for NERDTree
"nnoremap nerd :NERDTreeToggle<CR>

" for jellybeans
colorscheme jellybeans

" for taglist
nmap <F8> :Tagbar<CR>

" for indent guide
let g:indentguides_spacechar = '┆'
let g:indentguides_tabchar = '|'
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

" for vim-airline
set laststatus=2 " vim 하단에 삳태바 표시 ( 0 : 미표시 1 : 창이 2개일때 2 : 항상표시)
let g:airline#extensions#tabline#enabled = 1 " vim 상단 버퍼목록 (파일) 켜기 설정
let g:airline_theme='minimalist' " airline 테마 설정
let g:airline_highlighting_cache = 1 " 다양한 구문 강조 그룹의 캐싱 활성화
let g:airline_powerline_fonts = 1 " powerline 폰트와 통합하여  powerline의 기호들이 g:airline_symbols에 자동으로 채워진다.
let mapleader = ","
nnoremap <leader>q :bp<CR>
nnoremap <leader>w :bn<CR>

" for blueyed/vim-diminactive
let g:diminactive_enable_focus = 1

filetype plugin indent on               " python 자동 들여쓰기 on

" let g:syntastic_python_checkers=['flake8']        " ↓ 실행시 현재줄 주석 해제필요    
" let g:syntastic_python_flake8_args='--ignore='    " 무시하고자 하는 errorcode

"Plugin 'davidhalter/jedi-vim'   " python 자동완성 Plugin
"let g:jedi#show_call_signatures=0       " 자세히 설명하는 창을 보여준다 1=활성화, 0=비>활성화
"let g:jedi#popup_select_first=0       " 자동완성시 자동팝업 등장 x
"let g:jedi#force_py_version=3           " 자동완성 3 = python3 , 2 = python2

"---------------------------------------------Plugin 종료

"--------------------------------------------- vim 기본 설정


syntax enable           "구문 강조
set t_Co=256        "구문강조 색 변경
set encoding=utf-8  " eincoding 방식 설정
set nu              "Line 출력
set tabstop=4       "<Tab> key 4칸 이동
set shiftwidth=4	"<Tab>
set cursorline      "현재 줄 강조
set mouse=a	    "커서이동 마우스로도 가능
set smartindent " 자동들여쓰기
set hlsearch	" 검색시 하이라이팅 기능
set ignorecase	" 검색시 대소문자 구분하지 않음


"-------------------------------------------- vim 기본 설정 끝

"--------------------------------------------맨밑 상태바 표시 향상

set laststatus=2    "두줄로 표시
set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\  "현재 라인 위치 출력

"------------------------------------------- au filetype (파일타입지정)

au FileType python map <f2> : !python3 %


"------------------------------------------- NERDTree

autocmd BufEnter * lcd %:p:h
autocmd VimEnter * if !argc() | NERDTree | endif
nmap <leader>nt :NERDTreeToggle<cr>
let NERDTreeShowLineNumbers=1
let g:NERDTreeWinPos = "left"

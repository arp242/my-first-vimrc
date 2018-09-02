# The list of options on the left-hand side. They will be shown in the order
# defined here.
# 
# - comment   – shown in the overview and added to the vimrc file
# - default   – bool to indicate if this is checked by default
# - explainer – more detailed explainer to show, may be added to vimrc too.
# - value     – by default just "set [key]" is added to the vimrc file, with this you can override that.
window.options =
	'Basic options':
		_desc_: 'Usually a single option, but some be two or more.'

		nocompatible:
			comment: 'Vim defaults rather than vi ones. Keep at top.'
			default: true
			explainer: """
				<p>Ensure that Vim won't try to be compatible with the
				now-archaic 1970s vi. It influences a lot of Vim behaviour.</p>
				
				<p>This is not strictly required when loading from
				<code>~/.vimrc</code> or <code>~/.vim/vimrc</code> – as Vim will
				automatically set it when loading from those files – but it's
				not set automatically when loaded as <code>vim -u
				test.vim</code> or <code>:source test.vim</code>.</p>
				
				<p>Most people won't load it like that, but a single line is
				easy enough to add and will avoid <em>very</em> confusing errors
				down the line.</p>

				<p>You <strong>must</strong> keep this at the top, since
				changing the value resets many options. See 'nocompatible'.</p>
			"""

		filetype:
			comment: 'Enable filetype-specific settings.'
			default: true
			value: 'filetype plugin indent on'
			explainer: """
				<p>Vim ships with support for many languages, which is known as
					a 'filetype' in Vim jargon. A 'filetype' usually comes with a
					syntax file to control the syntax highlighting, but may also
					come with specific rules for indentation and may set
					settings specific for this 'filetype'.</p>

				<p>The default is to <em>not</em> use any of this though. This
					will enable detection of the filetype, which is usually done
					based on the filename's extension or the first line, and can be
					manually overridden with a 'modeline'.</p>

				<p>You almost certainly want to keep this.</p>
			"""

		syntax:
			comment: 'Enable syntax highlighting.'
			default: true
			value: 'syntax on'
			explainer: """
				<p>Enable syntax highlighting for this 'filetype'. This will
					implicitly enable 'filetype' detection ("filetype on").</p>

				<p>You almost certainly want to keep this.</p>
			"""

		backspace:
			comment: 'Make the backspace behave as most applications.'
			default: true
			value: 'set backspace=2'
			explainer: """
				<p>
				Vim's default behaviour when pressing the backspacing is somewhat
				peculiar, it won’t allow you to backspace to the previous line,
				automatically inserted indentation, or previously inserted text.</p>

				<p>With this value you will be able to to backspace over everything
				in insert mode, which is how almost any other application
				behaves.</p>

				<p>Also see
					<a target="_blank" href="https://vi.stackexchange.com/q/2162/51">Why doesn't the backspace key work in insert mode?</a>.
				</p>
			"""

		autoindent:
			comment: 'Use current indent for new lines.'
			default: true
			explainer: """
				<p>By default Vim will always place the cursor in the first
					column when starting a new line. When 'autoindent' is enabled it
					will use the same indentation as the previous line, which is
					often what you want.</p>

				<p>Note that there are more options to control indentation:
					'cindent' and 'smartindent'. You usually want to leave those
					alone as they <strong>will</strong> cause confusing
					behaviour in many programming languages. A 'filetype' that
					benefits from these will usually set one of those options,
					or use a custom 'indentexpr'.</p>
			"""

		display:
			comment: 'Show as much of the line as will fit.'
			default: true
			value: 'set display=lastline'
			explainer: """
				<p>By default Vim will display only "@" characters if the last
					line on the screen won't fit when 'wrap' is enabled.</p>

				<p>If this is enabled Vim will display as much as the last line
					as will fit and display "@@@" at the end.</p>

				<p>There is another useful option for 'display' that I rather
					like: "uhex". This will make Vim show unprintable characters
					as &lt;xx&gt; rather than ^L (Use |i_CTRL-V| in insert mode
					to see the difference.)</p>
			"""

		wildmenu:
			comment: 'Better tab completion in the commandline.'
			default: true
			alsoadd: [
				['set wildmode=list:longest', 'List all matches and complete to the longest match.']
			]
			explainer: """
				<p>Make commandline-completion (after you type <code>:</code>)
					behave more useful and roughly like most shells do.</p>

				<p>See 'wildmode' on how to configure the completion mode to
					your liking. 'wildignore' is also a useful setting to ignore
					binary files such as compiler output, images, etc.</p>
			"""

		showcmd:
			comment: 'Show (partial) command in bottom-right.'
			default: true
			explainer: """
				<p>Vim had many commands that consist of two or more keystrokes.
				If this option is enabled Vim will show the command you've typed
				thus-far in the bottom-right of the screen.</p>

				<p>It will also show the size of the selection in |visual-mode|.</p>
			"""

		expandtab:
			comment: 'Use spaces instead of tabs for indentation.'
			explainer: """
				<p>Vim will insert ‘real’ tabs by default. Setting this will
					make it insert spaces.</p>

				<p>Note that some 'filetype's may set this option to match that
					filetype's standard. See <code>:verbose set filetype</code> to
					see where it was last set. You can use an 'autocmd' to override
					the 'filetype' settings.</p>
			"""

		smarttab:
			comment: "Backspace removes 'shiftwidth' worth of spaces."
			default: true
			explainer: """
				<p>Remove 'shiftwidth' worth of spaces on backspace – like most
					editors – instead of just a single space.</p>
			"""

		number:
			comment: 'Show line numbers.'
			explainer: """
				<p>Vim won't directly show line numbers by default. This will enable
				a column with line numbers on the left-hand side of the screen.</p>

				<p>You can also show the current line number in the 'statusline' by
				setting 'ruler', or pressing |CTRL-G| or |g_CTRL-G|.</p>

				<p>Also see 'relativenumber' for showing line numbers as
				relative to the current line, 'numberwidth' for controlling the
				width, and |hl-LineNr| for controlling the colours.</p>
			"""

		wrap:
			comment: 'Wrap long lines.'
			default: true
			explainer: """
				<p>When long lines are <em>not</em> wrapped Vim will hide any text
				that's larger than the screen and scroll horizontally.</p> 

				<p>Also see 'breakindent' for continuing wrapped lines on the
				same indent level (requires Vim 7.4.338) and 'linebreak' to wrap
				only at the end of words.</p>

				<p>You can also use |gj| and |gk| to navigate "visual" lines
				more easily. Many people line to override the default behaviour
				by remapping keys with something like:</p>
<pre>nnoremap k      gk
nnoremap j      gj
nnoremap &lt;Up>   gk
nnoremap &lt;Down> gj
inoremap &lt;Down> &lt;C-o>gj
inoremap &lt;Up>   &lt;C-o>gk</pre>
			"""

		laststatus:
			comment: 'Always show the statusline.'
			default: true
			value: 'set laststatus=2'
			explainer: """
				<p>By default Vim will show the 'statusline' only if there are two
				or more windows.</p>
				
				<p>The statusline displays useful information about the current
				buffer and cursor position, so it’s useful to always show it.</p>

				<p>Also see 'statusline' for controlling/expanding the
				information shown here.</p>
			"""

		ruler:
			comment: 'Show the ruler in the statusline.'
			default: true
			explainer: """
				<p>The ruler is shown on the right side of the 'statusline' and usually
				contains information about the current cursor position and the like.</p>

				<p>Also see 'laststatus' to enable displaying the statusline and
				'rulerformat' for configuring what’s displayed here.</p>
			"""

		textwidth:
			comment: 'Wrap at n characters.'
			default: true
			default_val: 80
			type: 'text'
			explainer: """
				<p>Automatically break lines at <em>n</em> characters.</p>
			"""

		incsearch:
			comment: 'Jump to search match while typing.'
			explainer: """
				<p>Jump to the first match <em>while</em> typing the pattern with |/|.

				<p>The cursor will jump back to the original position when
					aborting (&lt;ESC&gt; or |CTRL-C|).</p>
			"""

		hlsearch:
			comment: 'Highlight the last used search pattern.'
			explainer: """
				<p>Highlight the last used search pattern.</p>

				<p>The last used search pattern is stored in the / register.
					This will highlight whatever is in that pattern.</p>

				<p>You can use |:nohlsearch| to clear the highlighting. Many
					people like to map this to e.g. |CTRL-L|:

				<pre>nnoremap &lt;silent> &lt;C-l> :nohlsearch&lt;CR>&lt;C-l></pre>
			"""

		ignorecase:
			comment: 'Searching with / is case-insensitive.'
			alsoadd: [
				['set smartcase', "Disable 'ignorecase' if the term contains upper-case."]
			]
			explainer: """
				<p>Case-insensitive searching unless the pattern contains an
					upper case letter or if |/\\C| is in the pattern.</p>

			"""

		nrformats:
			comment: "Remove octal support from 'nrformats'."
			default: true
			value: 'set nrformats-=octal'
			explainer: """
				<p>This controls how Vim should interpret numbers when pressing
				|CTRL-A| or |CTRL-X| to increment to decrement a number.
				By default numbers starting with a 0 are treated as octal
				numbers, which can be rather confusing, so remove that.
				</p>
			"""

		tabstop:
			comment: 'Size of a Tab character.'
			default: true
			default_val: 4
			alsoadd: [
				['set shiftwidth=0', "Use same value as 'tabstop'."],
				['set softtabstop=-1', "Use same value as 'shiftwidth'."]
			]
			type: 'text'
			explainer: """
				<p>Number of spaces to display tab characters as.</p>
			"""

		scrolloff:
			comment: 'Minimum number of lines to keep above/below cursor.'
			default_val: 5
			type: 'text'
			explainer: """
				<p>Keep lines above and below the screen when scrolling up or
					down. This is useful so you have some context what you’re
					scrolling to.</p>

				<p>Also see 'sidescrolloff'.</p>
			"""

	'Snippets':
		_desc_: 'Common but more advanced snippets.'

		formatoptions:
			comment: 'Control automatic formatting.'
			value: 'set formatoptions+=ncroqlj'
			explainer: """
				<p>The 'formatoptions' setting controls how automatic formatting
					when inserting text, formatting with |gq|, as well as
					some other commands.</p>
				<p>
					<code>n</code> – Recognize numbered lists when formatting (see 'formatlistpat').<br>
					<code>c</code> – Wrap comments with 'textwidth'.<br>
					<code>r</code> – Insert comment char after enter.<br>
					<code>o</code> – Insert comment char after |o|/|O|.<br>
					<code>q</code> – Format comments with |gq|.<br>
					<code>l</code> – Do not break lines when they were longer than 'textwidth' to start with.<br>
					<code>j</code> – Remove comment character when joining lines with |J|.<br>
				</p>
			"""

		store_tmp:
			comment: 'Store temporary files in <code>~/.vim/tmp</code>'
			value: """
				set viminfo+=n~/.vim/tmp/viminfo
				set backupdir=$HOME/.vim/tmp/backup
				set dir=$HOME/.vim/tmp/swap
				set viewdir=$HOME/.vim/tmp/view
				if !isdirectory(&backupdir) | call mkdir(&backupdir, 'p', 0700) | endif
				if !isdirectory(&dir)       | call mkdir(&dir, 'p', 0700)       | endif
				if !isdirectory(&viewdir)   | call mkdir(&viewdir, 'p', 0700)   | endif
			"""

			explainer: """
				<p>By default Vim will store various files in the current
					directory. These files are useful, but storing them in the
					current directory next to the original file usually isn’t.</p>

				<p>With this enabled Vim will store all these files in the
					user’s home directory.</p>
			"""

		undodir:
			comment: 'Persist undo history between Vim sessions.'
			value: """
				if has('persistent_undo')
					set undodir=$HOME/.vim/tmp/undo
					if !isdirectory(&undodir) | call mkdir(&undodir, 'p', 0700) | endif
				endif
			"""
			explainer: """
				<p>Store undo history to a file, so that it can be recalled in
					future Vim sessions.</p>

				<p>Also see
					<a href="https://vi.stackexchange.com/q/6/51">How can I use the undofile?</a> and
					<a href="https://vi.stackexchange.com/q/2115/51">Can I be notified when I'm undoing changes from the undofile?</a>.
				</p>
			"""

		matchit:
			comment: 'Load matchit.vim plugin.'
			value: """
				" Only load if the user hasn't installed a newer version.
				if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
					runtime! macros/matchit.vim
				endif """
			explainer: """
				<p>The matchit.vim plugin that comes bundled with Vim expands
					the |%| key to work with various programming language
					keywords (e.g. jumping between <code>if</code> and
					<code>end</code> in Ruby).</p>
			"""

		reselect:
			comment: ' Indent in visual and select mode automatically re-selects.'
			value: """
			vnoremap > >gv
			vnoremap < <gv
			"""
			explainer: """
				<p>Selecting some text in |visual-mode| and then changing the
					indentation with |v_>| and |v_<| will make Vim lose the
					visual selection, which is annoying if you want to change
					several levels of indentation.</p>

				<p>With this mapping it will re-select the last selection after
				using &lt; or &gt;.</p>
			"""

		# TODO: maybe set clipboard instead with this as tip?
		#clipboard:
		#	comment: ''
		#	value: """
		#		" Interface with system clipboard
		#		noremap <Leader>y "*y
		#		noremap <Leader>p "*p
		#		noremap <Leader>Y "+y
		#		noremap <Leader>P "+p
		#	"""
		#	explainer: """
		#		<p>TODO: Write an explainer here.</p>

		#		<p>Also see <a href="https://vi.stackexchange.com/a/96/51">this more in-depth explanation</a>.</p>
		#	"""

		last_cursor:
			comment: 'Go to the last cursor location when opening a file.'
			value: """
				augroup jump
					autocmd BufReadPost *
						\\  if line("'\\"") > 1 && line("'\\"") <= line("$") && &ft !~# 'commit'
							\\| exe 'normal! g`"'
						\\| endif
				augroup end
			"""
			explainer: """
				<p>Go to the last cursor location when a file is opened, unless
				this is a git commit (in which case it's annoying).</p>

				<p>This uses the information stored in the 'viminfo' file.</p>
			"""

		#superwrite:
		#	comment: 'Write a file as root user.'
		#	value: """
		#		fun! s:super_write()
		#			silent write !sudo tee %
		#			edit!
		#		endfun
		#		command! SuperWrite call s:super_write()
		#	"""
		#	explainer: """
		#		<p>TODO: Write an explainer here.</p>

		#		<p>Also see <a href="https://vi.stackexchange.com/a/475/51">this more in-depth explanation</a>.</p>
		#	"""

		whitespace:
			comment: 'Clean trailing whitespace.'
			value: """
				fun! s:trim_whitespace()
					let l:save = winsaveview()
					keeppatterns %s/\\s\\+$//e
					call winrestview(l:save)
				endfun
				command! TrimWhitespace call s:trim_whitespace()
			"""
			explainer: """
				<p>This command removes all trailing whitespace in a file,
					without causing any side-effects.</p>

				<p>Also see <a href="https://vi.stackexchange.com/a/454/51">What's the simplest way to strip trailing whitespace from all lines in a file?</a>.</p>
			"""

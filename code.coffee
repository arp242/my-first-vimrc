# Get correct HTML input line for this option
option_to_input = (id, o, id_prefix='', no_label=false) ->
	o.type = 'checkbox' unless o.type

	out = """
		<input
			id="#{id_prefix}#{id}"
			type="checkbox"
			#{'checked="checked"' if o.default}
		>
		<span class="label">
	"""

	if o.type isnt 'checkbox'
		out += """
			<input
				id="#{id_prefix}#{id}-val"
				type="#{o.type}"
				#{"value='#{o.default_val}'" if typeof o.default_val not in ['undefined', 'boolean']}
			>
		"""

	unless no_label
		out += """
			<label for="#{id_prefix}#{id}"><code>#{id}</code></label>
		"""

	return out + '</span>'

# Populate the settings with the list from options.coffee.
populate_settings = ->
	$('#settings').html ''
	for section, s_options of options
		$('#settings').append "<h2>#{section} – <small>#{options[section]._desc_}</small></h2>"

		for k, v of s_options
			continue if k[0] is '_'

			v = options[section][k]
			$('#settings').append """
				<div>
					#{option_to_input k, v}
					<span class="toggle-explainer">#{v.comment}</span>
					<span class="explainer">#{helpify v.explainer}</span>
				</div>
			"""

# Convert a selected option to one or more lines to stick in vimrc.
#
# The actual Vimscript and corresponding comment are returned separately so that
# various formatting decisions can be made later.
option_to_vimrc = (option_name) ->
	option = get_option option_name

	value = option.value
	if option.type is 'text'
		value = "set #{option_name}=#{$("##{option_name}-val").val()}"
	else if typeof value is 'undefined'
		value = "set #{option_name}"

	comment = option.comment

	# Add explainer.
	comment += "<br><br>#{option.explainer}" if get_hash()['add-explainers'] is '1'
	return [value, comment]

get_option = (name) ->
	s_options[name] if s_options[name] for section, s_options of options

# Generate the vimrc file.
generate_vimrc = ->
	output = []
	$('#settings input[type=checkbox]').each ->
		input = $(this)
		if input.attr('type') is 'checkbox' and not input.is(':checked')
			return

		option_name = input.attr 'id'
		output.push option_to_vimrc(option_name)
		opt = get_option option_name
		if opt.alsoadd
			output.push a for a in opt.alsoadd

	# Get the longest line so we know how many spaces to add between the
	# settings and comments.
	spaces = 2 + longest_option_value()

	# Now generate the vimrc file.
	vimrc = ''
	output.forEach (line) ->
		# For long lines always place the comment above the line(s).
		if line[0].length > spaces or spaces + line[1].length > 80
			vimrc += """\n#{html_to_vim_comment line[1]}\n#{line[0]}\n\n"""
		# For simple/short settings add comments after the option
		else
			vimrc += """#{line[0]}#{' '.repeat spaces - line[0].length}" #{line[1]}\n"""

	$('#vimrc').text vimrc.trim().replace(/\n{2,}/g, '\n\n')
	$('#download-btn').attr 'href', "data:text/plain;charset=utf-8,#{encodeURIComponent $('#vimrc').text()}"


# Get the length of longest value of all options.
longest_option_value =  ->
	l = 0
	for k, v of options['Basic options']
		# Add 4 since we later add "set "
		k += 4
		k = v.value if v.value

		# Don't count comments with newlines.
		continue if '\n' in k

		l = k.length if k.length > l
	return l

# Toggle the visibility of the explainer belonging to this element.
toggle_explain = (elem) ->
	explainer = $(this).next()[0]
	if explainer.style.display is 'block'
		explainer.style.display = 'none'
	else
		explainer.style.display = 'block'

toggle_intro = (do_show=null) ->
	intro = $('#intro')
	do_show = intro.is ':visible' if do_show is null

	if do_show
		intro.css 'display', 'block'
		$('#toggle-intro').html 'hide'
	else
		intro.css 'display', 'none'
		$('#toggle-intro').html 'show'

# Parse the current hash and return it as a key/value object.
get_hash = (hash='') ->
	values = {}
	(hash or window.location.hash)
		.replace /^#/, ''
		.split '&'
		.forEach (v) ->
			v = v.split '='
			values[v[0]] = decodeURIComponent v[1] if v[0]
	return values

# Set value in URL.
set_hash = (key, value) ->
	values = get_hash()
	values[key] = value

	hash = []
	for k, v of values
		hash.push "#{k}=#{encodeURIComponent v}"

	window.location.hash = '#' + hash.join '&'

# Set value in URL only if it's not set yet.
init_hash = (key, value) ->
	v = get_hash()[key]
	set_hash key, value if typeof v is 'undefined'

toggle_hash = (key) ->
	set_hash key, if get_hash()[key] is '1'
					'0'
				else
					'1'

# Get an option by key name.
get_option = (key) ->
	for _, s_options of options
		for k, option of s_options
			return option if k is key

wizard_show_step = ->
	step = parseInt get_hash()['wizard-step'], 10

	$('#wizard-prev, #wizard-next').css 'display', ''
	if step is 0
		$('#wizard-current').html $('#wizard-intro').html()
		$('#wizard-prev').css 'display', 'none'
	else
		if step is $('#settings input').length
			$('#wizard-next').css 'display', 'none'

		inp = $("#settings input:eq(#{step - 1})")
		k = inp.attr 'id'
		option = get_option k

		option.default = inp.is ':checked'
		$('#wizard-current').html """
			#{option_to_input k, option, 'wiz-', true}
			<label for="wiz-#{k}"><strong><code>#{k}</code></strong></label> – #{option.comment}<br><br>
			#{helpify option.explainer}
		"""

		$('#wizard-current input').on 'change', -> $("##{k}").trigger 'click'

html_to_vim_comment = (html) ->
	html
		.replace /<br>/g, '%%\n'                                # Add newlines.
		.replace /<(em|strong)>(.+?)<\/(em|strong)>/g, '*$2*'   # Faux-emphasis.
		.replace /<\/p>/g, '\n\n\n\n'                           # Make sure that paragraphs are a block.
		.replace /<a.*?href="(.*?)".*?>(.+?)<\/a>/g, '"$2": $1' # Links.
		.replace /<\/?.+?>/g, ''                                # Remove remaining HTML tags.
		.replace /\n{2,}/g, '\n\n'                              # Trim excessive newlines.
		.split '\n\n'                                           # Split by paragraph.
		.map (p) ->                                             # Wrap paragraphs.
			word_wrap p.replace(/\n/g, ' ').trim().replace /[ \t]+/g, ' '
		.filter (p) -> p isnt ''
		.join '\n\n'
		.replace /%%\n/g, ''                                  # Hack to remove newlines when using <br>
		.replace /%%/g, ''
		.trim()
		.split '\n'
		.map (c) -> if c is '' then '"' else '" ' + c         # Add comment characters.
		.join '\n'

# Based on https://stackoverflow.com/a/14502311/660921
word_wrap = (text, width=78) ->
	return text if text.length <= width

	p = width
	while true
		break if p < 0
		break if text[p] is ' '
		p -= 1

	if p > 0
		left = text.substring 0, p
		right = text.substring p + 1
		return "#{left}\n#{word_wrap right, width}"


# Almost all actions are done by changing the URL so that we can easily make a
# permalink.
window.onhashchange = (e) ->
	old = get_hash e.oldURL.hash
	n = get_hash e.newURL.hash

	# TODO: get list of changed options.
	changed = n

	for k, v of changed
		switch k
			when 'hide-intro'
				toggle_intro !parseInt(v, 10)
			when 'show-all'
				if !!parseInt(v, 10)
					$('.explainer').css 'display', 'block'
				else
					$('.explainer').css 'display', 'none'
			when 'add-explainers'
				generate_vimrc()
			when 'options'
				opts = $('#settings input').toArray()
				get_hash()['options'].split('').forEach (v, i) ->
					opts[i].checked = !!parseInt(v, 10)
				generate_vimrc()
			when 'wizard-step'
				wizard_show_step()
			when 'wizard-active'
				if !!parseInt(v, 10)
					$('#wizard').css 'display', 'block'
					$('#settings, #toggle-all-explainers, #toggle-all-explainers + label').css 'display', 'none'
				else
					$('#wizard').css 'display', 'none'
					$('#settings, #toggle-all-explainers, #toggle-all-explainers + label').css 'display', ''

# Add help links and formatting to the text.
# 'opt' -> some Vim option
# <k> -> A key press
# |anything| -> any help tag.
helpify = (text) ->
	text
		.replace /('\w+')/g, (m) ->
			url = "http://vimhelp.appspot.com/options.txt.html##{encode_uri m}"
			return "<a class='help-option' target='_blank' href='#{url}'>#{m.replace /'/g, ''}</a>"
		#.replace /(&lt;[\w-<>]+&gt;)/g, (m) ->
		#	url = "http://vimhelp.appspot.com/#{tagfile m}.txt.html##{encode_uri m}"
		#	return "<a class='help-key' target='_blank' href='#{url}'>#{m}</a>"
		.replace /\|([\w-/:\\<>%]+)\|/g, (_, m) ->
			# TODO: Get correct .txt file
			url = "http://vimhelp.appspot.com/#{tagfile m}.txt.html##{encode_uri m}"
			return "<a class='help-key' target='_blank' href='#{url}'>#{m}</a>"

helptags =
	'%':           'motion'
	'/':           'pattern'
	'/\\C':        'pattern'
	':nohlsearch': 'pattern'
	'<ESC>':       'intro'
	'<gq>':        'change'
	'CTRL-A':      'change'
	'CTRL-C':      'pattern'
	'CTRL-G':      'editing'
	'CTRL-L':      'various'
	'CTRL-X':      'change'
	'J':           'insert'
	'O':           'insert'
	'g_CTRL-G':    'editing'
	'gj':          'motion'
	'gk':          'motion'
	'gq':          'change'
	'hl-LineNr':   'syntax'
	'i_CTRL-V':    'insert'
	'o':           'insert'
	'v_<':         'change'
	'v_>':         'change'
	'visual-mode': 'visual'

tagfile = (tag) ->
	tag = tag.replace('&lt;', '<').replace('&gt;', '>')
	f = helptags[tag]
	console.log "no file for #{tag}" unless f
	return f

encode_uri = (uri) ->
	encodeURIComponent(uri)
		.replace /'/g, '%27'

set_instructions = ->
	locations =
		vim:
			windows: 'C:\\Users\\USERNAME\\vimfiles\\vimrc'
			unix: '$HOME/.vim/vimrc'
		neovim:
			windows: 'C:\\Users\\USERNAME\\AppData\\Local\\nvim\\init.vim'
			unix: '$HOME/.config/nvim/init.vim'


	if $('#use-neovim').is ':checked'
		l = locations.neovim
	else
		l = locations.vim
	if $('#use-windows').is ':checked'
		l = l.windows
	else
		l = l.unix

	text = """
		<p>Copy the output file to <code>#{l}</code>.
		Make the directory if it doesn’t exist yet.</p>
	"""

	unless $('#use-neovim').is ':checked'
		text += """<p>
			Vim will also load <code>$HOME/.vimrc</code> and
			<code>C:\\Users\\USERNAME\\_vimrc</code>, but the above locations
			are recommended. You may want to check if your system has this file
			already to make sure you’ve got only one vimrc file.
		"""

	$('#use-text').html text

# Let's go!
$(document).ready ->
	hash = get_hash()
	$('#toggle-wizard').attr 'checked', true if hash['wizard-active'] is '1'
	$('#add-explainers').attr 'checked', true if hash['add-explainers'] is '1'
	$('#toggle-all-explainers').attr 'checked', true if hash['show-all'] is '1'

	populate_settings()
	set_instructions()
	$('#use-neovim, #use-windows').on 'change', set_instructions

	window.onhashchange
		oldURL:
			hash: ''
		newURL:
			hash: window.location.hash

	generate_vimrc()

	$('#toggle-intro').on 'click', -> toggle_hash 'hide-intro'
	$('#add-explainers').on 'click', -> toggle_hash 'add-explainers'
	$('#toggle-all-explainers').on 'change', -> toggle_hash 'show-all'
	$('#toggle-wizard').on 'change', ->
		toggle_hash 'wizard-active'
		init_hash 'wizard-step', '0'

	$('#wizard-next').on 'click', ->
		set_hash 'wizard-step', parseInt(get_hash()['wizard-step'], 10) + 1
	$('#wizard-prev').on 'click', ->
		set_hash 'wizard-step', parseInt(get_hash()['wizard-step'], 10) - 1

	# No permalink for this one. That's probably fine.
	$('#settings').on 'click', '.toggle-explainer', toggle_explain

	$('#settings').on 'change', 'input', (e) ->
		set_hash 'options',
			# TODO: Don't use indexed; makes it difficult to add stuff later.
			$('#settings input').toArray()
				.map (x) -> if x.checked then '1' else '0'
				.join ''

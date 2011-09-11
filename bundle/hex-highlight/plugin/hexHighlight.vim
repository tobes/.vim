"gvim plugin for highlighting hex codes to help with tweaking colors
"
"Last Change: 2010 Jan 21
"Maintainer: Yuri Feldman <feldman.yuri1@gmail.com>
"License: WTFPL - Do What The Fuck You Want To Public License.
"Email me if you'd like.
let s:HexColored = 0
let s:HexColors = []

map <Leader><F2> :call HexHighlight()<Return>
function! HexHighlight()
    if has("gui_running")
        if s:HexColored == 0
            let hexGroup = 4
            let lineNumber = 0
			let hex6reg = '\(#\)\(\x\x\)\(\x\x\)\(\x\x\)'
			let hex3reg = '\(#\)\(\x\)\(\x\)\(\x\)'
            while lineNumber <= line("$")
                let currentLine = getline(lineNumber)
                let hexLineMatch = 1
                while match(currentLine, '#\x\{3}\(\x\{3}\)\?', 0, hexLineMatch) != -1
                    let hexMatch = matchstr(currentLine, '#\x\{3}\(\x\{3}\)\?', 0, hexLineMatch)
					" work out if black or white is a good contrast
					if match(hexMatch, hex6reg) != -1
						let red = str2nr(substitute(hexMatch, hex6reg, '\2', ''),16)
						let green = str2nr(substitute(hexMatch, hex6reg, '\3', ''),16)
						let blue = str2nr(substitute(hexMatch, hex6reg, '\4', ''),16)
					else
						let red = str2nr(substitute(hexMatch, hex3reg, '\2', ''),16)
						let green = str2nr(substitute(hexMatch, hex3reg, '\3', ''),16)
						let blue = str2nr(substitute(hexMatch, hex3reg, '\4', ''),16)
						let red = (red * 16) + red
						let green = (green * 16) + green
						let blue = (blue * 16) + blue
					endif
					if (red * 299) + (green * 587) + (blue * 114) > 125000 && red + green + blue > 500
						let hexFg = '#000000'
					else
						let hexFg = '#FFFFFF'
					endif

                    exe 'hi hexColor'.hexGroup.' guifg='.hexFg.' guibg='.hexMatch
                    exe 'let m = matchadd("hexColor'.hexGroup.'", "'.hexMatch.'", 25, '.hexGroup.')'
                    let s:HexColors += ['hexColor'.hexGroup]
                    let hexGroup += 1
                    let hexLineMatch += 1
                endwhile
                let lineNumber += 1
            endwhile
            unlet lineNumber hexGroup
            let s:HexColored = 1
            echo "Highlighting hex colors..."
        elseif s:HexColored == 1
            for hexColor in s:HexColors
                exe 'highlight clear '.hexColor
            endfor
            call clearmatches()
            let s:HexColored = 0
            echo "Unhighlighting hex colors..."
        endif
    else
        echo "hexHighlight only works with a graphical version of vim"
    endif
endfunction

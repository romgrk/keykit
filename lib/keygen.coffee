
_ = require 'underscore-plus'

tab = 0
console.debug = (a...) ->
    s = ''
    tabstr = ''
    if a.length > 1 and typeof a[0] is 'number'
        tabstr += '    ' for i in [1..a[0]]
        a.shift()

    for o in a
        if typeof o is 'object'
            s += CSON.stringify o
            s = s.split('\n').join('\n'+tabstr)
        else
            s += o
        s += ' '
    console.log tabstr + s

CSON = require 'season'
# obj = {true: 'a', false: 'b'}
# console.debug obj[true]

class KeyCode
    @init: ->
        # for keycode, keyname of @keynameByCode
            # console.debug keycode, ':', keyname
        KC = {}
        KEY = {}
        for code, sysname of @sysnames
            typesys = typeof sysname
            code = parseInt(code)
            if typesys is 'string'
                continue if sysname.match /WIN_/
            name = @keynameByCode[code] ? null
            if sysname.length == 1 or typeof sysname == 'number'
                sysname = 'KEY_' + sysname


            # console.debug 2, sysname, ':'
            # console.debug 3, 'code :', code
            # console.debug 3, "name :\"#{name.replace('"', '\\"')}\"" if name?

            if (sysname is '') or sysname.match /^WIN/
                continue

            printable = not (_.contains @nonPrintableCodes, code)

            chars = null
            shiftable = false
            if name?
                if name.match /^[a-zA-Z]$/
                    chars = [name.toLowerCase(), name.toUpperCase()]
                    shiftable = true
                else if @unshiftedToShifted[name]?
                    chars = [name, @unshiftedToShifted[name]]
                    shiftable = true
                else if printable and name.match /^NUMPAD\d/
                    num = name.substring(6)
                    chars = num
                else if printable
                    chars = name

            # console.debug sysname, (_.contains @nonPrintableCodes, code)
            KC[code] = {
                name: name
                sysname: sysname
                printable: printable
                visible: printable and not (_.contains [9, 13, 32], code)
                char: chars
            }
            KEY[sysname] = {
                name: name
                code: code
                printable: printable
                visible: printable and not (_.contains [9, 13, 32], code)
                char: chars
            }
        console.debug KEY

        # console.debug code, data.sysname for code, data of KC when data.printable == true

        # noprint = _.uniq @nonPrintableCodes
        # buf = ''
        # for n in noprint
        #     if (buf + n + ', ').length > 50
        #         console.debug buf
        #         buf = ''
        #     else
        #         buf += n + ', '


# keyCode
# idx:int           keycode
#   name:String
#   char:String     produced char, if applicable
#

    @nonPrintableCodes: [
        16, 17, 18, 224, 225, 8, 27, 33, 34, 35, 36, 37,
        39, 40, 45, 46, 112, 113, 114, 115, 116, 117, 118
        119, 120, 121, 122, 123, 124, 125, 126, 127, 128,
        130, 131, 132, 133, 134, 135, 3, 6, 12, 19, 20,
        22, 23, 24, 25, 28, 29, 30, 31, 41, 42, 43, 44,
        95, 144, 145, 181, 182, 183, 246, 247, 248, 249,
        250, 251, 253, 224, 225, 93, 38, 21, 129
        ]

    @nonPrintableNames: [
        "shift", "control", "alt", "meta", "altgr"
        "backspace", "escape",
        "pageup", "pagedown", "end", "home",
        "left", "up", "right", "down",
        "insert", "delete",
        "f1", "f2", "f3", "f4", "f5", "f6",
        "f7", "f8", "f9", "f10", "f11", "f12",
        "f13", "f14", "f15", "f16", "f17", "f18",
        "f19", "f20", "f21", "f22", "f23", "f24" ]

    @shiftedToUnshifted:
        "~": "`",  "!": "1",  "@": "2",  "#": "3",  "$": "4",  "%": "5",
        "^": "6",  "&": "7",  "*": "8",  "(": "9",  ")": "0",  "_": "-",
        "+": "=",  "{": "[",  "}": "]",  ":": ";",  "\"": "'",  "|": "\\",
        "<": ",",  ">": ".",  "?": "/"

    @unshiftedToShifted:
        '`': '~',  '1': '!',  '2': '@',  '3': '#',  '4': '$',  '5': '%',
        '6': '^',  '7': '&',  '8': '*',  '9': '(',  '0': ')',  '-': '_',
        '=': '+',  '[': '{',  ']': '}',  ';': ':',  '\'': '"',  '\\': '|',
        ',': '<',  '.': '>',  '/': '?'

    @keycodeByName:
        "backspace": 8,  "tab": 9,  "enter": 13,  "return": 14,  "shift": 16,
        "control": 17,  "alt": 18,  "escape": 27,  "space": 32,  "pageup": 33,
        "pagedown": 34,  "end": 35,  "home": 36,  "left": 37,  "up": 38,  "right": 39,
        "down": 40,  "insert": 45,  "delete": 46,
        "0": 48,  "1": 49,  "2": 50,  "3": 51,  "4": 52,  "5": 53,  "6": 54,
        "7": 55,  "8": 56,  "9": 57,
        "A": 65,  "B": 66,  "C": 67,  "D": 68,  "E": 69,  "F": 70,  "G": 71,
        "H": 72,  "I": 73,  "J": 74,  "K": 75,  "L": 76,  "M": 77,  "N": 78,  "O": 79,
        "P": 80,  "Q": 81,  "R": 82,  "S": 83,  "T": 84,  "U": 85,  "V": 86,  "W": 87,
        "X": 88,  "Y": 89,  "Z": 90
        "a": 65,  "b": 66,  "c": 67,  "d": 68,  "e": 69,  "f": 70,  "g": 71,
        "h": 72,  "i": 73,  "j": 74,  "k": 75,  "l": 76,  "m": 77,  "n": 78,  "o": 79,
        "p": 80,  "q": 81,  "r": 82,  "s": 83,  "t": 84,  "u": 85,  "v": 86,  "w": 87,
        "x": 88,  "y": 89,  "z": 90,  "f1": 112,  "f2": 113,  "f3": 114,  "f4": 115,
        "f5": 116,  "f6": 117,  "f7": 118,  "f8": 119,  "f9": 120,  "f10": 121,
        "f11": 122,  "f12": 123,  "f13": 124,  "f14": 125,  "f15": 126,  "f16": 127,
        "f17": 128,  "f18": 129,  "f19": 130,  "f20": 131,  "f21": 132,  "f22": 133,
        "f23": 134,  "f24": 135,  ";": 186,  "=": 187,  ",": 188,  "-": 189,  ".": 190,
        "/": 191,  "`": 192,  "[": 219,  "\\": 220,  "]": 221,  "'": 222,  "meta": 224,
        "altgr": 225

    @keynameByCode:
        16: "shift", 17: "control", 18: "alt", 224: "meta", 225: "altgr"
        8: "backspace", 9: "tab", 13: "enter", 14: "return", 27: "escape", 32: "space",
        33: "pageup", 34: "pagedown", 35: "end", 36: "home",
        37: "left", 38: "up", 39: "right", 40: "down",
        45: "insert", 46: "delete",
        224: "meta", 225: "altgr",

        12: "clear"
        160: "^", 161: "!", 162: '"', 163: '#',
        164: "$", 165: "%", 166: "&", 167: "_", 168: "(", 169: ")", 170: "*",
        171: "+", 172: "|", 173: "-", 174: "{", 175: "}", 176: "~",
        58: ":", 59: ";", 60: "<", 61: "=", 62: ">", 63: "?", 64: "@",
        96: "NUMPAD0", 97: "NUMPAD1", 98: "NUMPAD2", 99: "NUMPAD3",
        100: "NUMPAD4", 101: "NUMPAD5", 102: "NUMPAD6", 103: "NUMPAD7",
        104: "NUMPAD8", 105: "NUMPAD9", 106: "*", 107: "+", 108: "SEPARATOR",
        109: "-", 110: ".", 111: "/"

        112: "f1", 113: "f2", 114: "f3", 115: "f4", 116: "f5", 117: "f6",
        118: "f7", 119: "f8", 120: "f9", 121: "f10", 122: "f11", 123: "f12",
        124: "f13", 125: "f14", 126: "f15", 127: "f16", 128: "f17", 129: "f18",
        130: "f19", 131: "f20", 132: "f21", 133: "f22", 134: "f23", 135: "f24",
        48: "0", 49: "1", 50: "2", 51: "3", 52: "4", 53: "5", 54: "6",
        55: "7", 56: "8", 57: "9",
        65: "A", 66: "B", 67: "C", 68: "D", 69: "E", 70: "F", 71: "G", 72: "H",
        73: "I", 74: "J", 75: "K", 76: "L", 77: "M", 78: "N", 79: "O", 80: "P",
        81: "Q", 82: "R", 83: "S", 84: "T", 85: "U", 86: "V", 87: "W", 88: "X",
        89: "Y", 90: "Z",
        186: ";", 187: "=", 188: ",", 189: "-", 190: ".", 191: "/", 192: "`",
        219: "[", 220: "\\", 221: "]", 222: "'"

    @keycharByCode:
        9: "\t", 13: "\n", 32: " ",
        48: "0", 49: "1", 50: "2", 51: "3", 52: "4", 53: "5", 54: "6",
        55: "7", 56: "8", 57: "9",
        65: "a", 66: "b", 67: "c", 68: "d", 69: "e", 70: "f", 71: "g", 72: "h",
        73: "i", 74: "j", 75: "k", 76: "l", 77: "m", 78: "n", 79: "o", 80: "p",
        81: "q", 82: "r", 83: "s", 84: "t", 85: "u", 86: "v", 87: "w", 88: "x",
        89: "y", 90: "z",
        186: ";", 187: "=", 188: ",", 189: "-", 190: ".", 191: "/", 192: "`",
        219: "[", 220: "\\", 221: "]", 222: "'"

    @keynameByVimCode:
        'BS': 'backspace', 'TAB': 'tab', 'CR': 'enter', 'ESC': 'escape',
        'SPACE': 'space', 'END': 'end', 'HOME': 'home', 'UP': 'up',
        'DOWN': 'down', 'RIGHT': 'right', 'LEFT': 'left', 'DEL': 'delete',
        'BAR': '|', 'LT': '<', '<LT>': '<',
        'F1': 'f1',  'F2': 'f2',  'F3': 'f3',  'F4': 'f4',  'F5': 'f5',
        'F6': 'f6',  'F7': 'f7',  'F8': 'f8',  'F9': 'f9',  'F10': 'f10',
        'F11': 'f11',  'F12': 'f12',  'F13': 'f13',  'F14': 'f14',
        'F15': 'f15',  'F16': 'f16',  'F17': 'f17',  'F18': 'f18',
        'F19': 'f19',  'F20': 'f20',  'F21': 'f21',  'F22': 'f22',
        'F23': 'f23',  'F24': 'f24'
        # not official
        'CTRL': 'ctrl', 'ALT': 'alt', 'SHIFT': 'shift'

    @vimCodeByKeyname:
        backspace: "BS", tab: "TAB", enter: "CR", escape: "ESC", space: "SPACE",
        end: "END", home: "HOME", up: "UP", down: "DOWN", right: "RIGHT",
        left: "LEFT", delete: "DEL", "|": "BAR", "<": "LT", f1: "F1",
        f2: "F2", f3: "F3", f4: "F4", f5: "F5", f6: "F6", f7: "F7", f8: "F8",
        f9: "F9", f10: "F10", f11: "F11", f12: "F12", f13: "F13", f14: "F14",
        f15: "F15", f16: "F16", f17: "F17", f18: "F18", f19: "F19", f20: "F20",
        f21: "F21", f22: "F22", f23: "F23", f24: "F24",
        ctrl: "CTRL", alt: "ALT", shift: "SHIFT"

    @normalKeyStrokeRegex: ///
        ^(
            control|alt|shift
        )|(?:
            (ctrl-)?
            (alt-)?
            (shift-)?
            (
                .| enter|space|backspace|delete|tab|escape
                |pageup|pagedown|home|end|left|right|up|down|f\d{1,2} )
        )
        $

        ///

    @vimEscapedRegex: ///
        <(
        (?:
            (
                (?:[CSAM]-)+
            )?

            (BS|TAB|CR|ESC|SPACE|PAGEUP|
            PAGEDOWN|END|HOME|LEFT|UP|
            RIGHT|DOWN|DEL|BAR|F\d{1,2}|<LT>|.)
        )
        | LT
        )>
        ///i

    @vimSequenceRegex: ///
        ([^<]|<(
        (?:
            ( (?:[CSAM]-)+ )?
            (BS|TAB|CR|ESC|SPACE|PAGEUP|
            PAGEDOWN|END|HOME|LEFT|UP|
            RIGHT|DOWN|DEL|BAR|F\d{1,2}|<LT>|.)
        )
        | LT )>)
        ///gi

    @sysnames:
        3: "CANCEL"
        6: "HELP"
        8: "BACK_SPACE"
        9: "TAB"
        12: "CLEAR"
        13: "ENTER"
        14: "RETURN"
        16: "SHIFT"
        17: "CONTROL"
        18: "ALT"
        19: "PAUSE"
        20: "CAPS_LOCK"
        21: "KANA"
        22: "EISU"
        23: "JUNJA"
        24: "FINAL"
        25: "HANJA"
        27: "ESCAPE"
        28: "CONVERT"
        29: "NONCONVERT"
        30: "ACCEPT"
        31: "MODECHANGE"
        32: "SPACE"
        33: "PAGE_UP"
        34: "PAGE_DOWN"
        35: "END"
        36: "HOME"
        37: "LEFT"
        38: "UP"
        39: "RIGHT"
        40: "DOWN"
        41: "SELECT"
        42: "PRINT"
        43: "EXECUTE"
        44: "PRINTSCREEN"
        45: "INSERT"
        46: "DELETE"
        48: 0
        49: 1
        50: 2
        51: 3
        52: 4
        53: 5
        54: 6
        55: 7
        56: 8
        57: 9
        58: "COLON"
        59: "SEMICOLON"
        60: "LESS_THAN"
        61: "EQUALS"
        62: "GREATER_THAN"
        63: "QUESTION_MARK"
        64: "AT"
        65: "A"
        66: "B"
        67: "C"
        68: "D"
        69: "E"
        70: "F"
        71: "G"
        72: "H"
        73: "I"
        74: "J"
        75: "K"
        76: "L"
        77: "M"
        78: "N"
        79: "O"
        80: "P"
        81: "Q"
        82: "R"
        83: "S"
        84: "T"
        85: "U"
        86: "V"
        87: "W"
        88: "X"
        89: "Y"
        90: "Z"
        91: "WIN"
        93: "CONTEXT_MENU"
        95: "SLEEP"
        96: "NUMPAD0"
        97: "NUMPAD1"
        98: "NUMPAD2"
        99: "NUMPAD3"
        100: "NUMPAD4"
        101: "NUMPAD5"
        102: "NUMPAD6"
        103: "NUMPAD7"
        104: "NUMPAD8"
        105: "NUMPAD9"
        106: "MULTIPLY"
        107: "ADD"
        108: "SEPARATOR"
        109: "SUBTRACT"
        110: "DECIMAL"
        111: "DIVIDE"
        112: "F1"
        113: "F2"
        114: "F3"
        115: "F4"
        116: "F5"
        117: "F6"
        118: "F7"
        119: "F8"
        120: "F9"
        121: "F10"
        122: "F11"
        123: "F12"
        124: "F13"
        125: "F14"
        126: "F15"
        127: "F16"
        128: "F17"
        129: "F18"
        130: "F19"
        131: "F20"
        132: "F21"
        133: "F22"
        134: "F23"
        135: "F24"
        144: "NUM_LOCK"
        145: "SCROLL_LOCK"
        146: "WIN_OEM_FJ_JISHO"
        147: "WIN_OEM_FJ_MASSHOU"
        148: "WIN_OEM_FJ_TOUROKU"
        149: "WIN_OEM_FJ_LOYA"
        150: "WIN_OEM_FJ_ROYA"
        160: "CIRCUMFLEX"
        161: "EXCLAMATION"
        162: "DOUBLE_QUOTE"
        163: "HASH"
        164: "DOLLAR"
        165: "PERCENT"
        166: "AMPERSAND"
        167: "UNDERSCORE"
        168: "OPEN_PAREN"
        169: "CLOSE_PAREN"
        170: "ASTERISK"
        171: "PLUS"
        172: "PIPE"
        173: "HYPHEN_MINUS"
        174: "OPEN_CURLY_BRACKET"
        175: "CLOSE_CURLY_BRACKET"
        176: "TILDE"
        181: "VOLUME_MUTE"
        182: "VOLUME_DOWN"
        183: "VOLUME_UP"
        186: "SEMICOLON"
        187: "EQUALS"
        188: "COMMA"
        189: "MINUS"
        190: "PERIOD"
        191: "SLASH"
        192: "BACK_QUOTE"
        219: "OPEN_BRACKET"
        220: "BACK_SLASH"
        221: "CLOSE_BRACKET"
        222: "QUOTE"
        224: "META"
        225: "ALTGR"
        227: "WIN_ICO_HELP"
        228: "WIN_ICO_ 00"
        230: "WIN_ICO_CLEAR"
        233: "WIN_OEM_RESET"
        234: "WIN_OEM_JUMP"
        235: "WIN_OEM_PA 1"
        236: "WIN_OEM_PA 2"
        237: "WIN_OEM_PA 3"
        238: "WIN_OEM_WSCTRL"
        239: "WIN_OEM_CUSEL"
        240: "WIN_OEM_ATTN"
        241: "WIN_OEM_FINISH"
        242: "WIN_OEM_COPY"
        243: "WIN_OEM_AUTO"
        244: "WIN_OEM_ENLW"
        245: "WIN_OEM_BACKTAB"
        246: "ATTN"
        247: "CRSEL"
        248: "EXSEL"
        249: "EREOF"
        250: "PLAY"
        251: "ZOOM"
        253: "PA1"
        254: "WIN_OEM_CLEAR"

KeyCode.init()

#Requires AutoHotkey v2.0.2
#SingleInstance Force

; Reloading and Exiting the script {{{
~Home:: ; Doubletapping Home will reload the script. {{{
{
    if (A_PriorHotkey != "~Home" or A_TimeSincePriorHotkey > 400)
    {
        ; Too much time between presses, so this isn't a double-press.
        KeyWait "Home"
        return
    }
    Reload
} ; }}}
#End::ExitApp   ; Win-End will terminate the script.
; }}}

; Main binds to Komorebic {{{

Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

WinSetTransparent 0, "ahk_class Shell_TrayWnd"

#g::
{
    Komorebic("gui")
    Return
}

#c::Komorebic("close")
#m::Komorebic("minimize")
#+m::Komorebic("manage")
; #q::Run "C:\Program Files\WezTerm\wezterm-gui.exe"    ; Including the Windows Essentials version of this

; Focus windows
#h::Komorebic("focus left")
#d::Send "#{h}"                 ; Since Win+H is used to move window left, re-bind Win+D to open dictation
#j::Komorebic("focus down")
#k::Komorebic("focus up")
#l::Komorebic("focus right")

#+[::Komorebic("cycle-focus previous")
#+]::Komorebic("cycle-focus next")

; Move windows
#+h::Komorebic("move left")
#+j::Komorebic("move down")
#+k::Komorebic("move up")
#+l::Komorebic("move right")

; Stack windows
#Left::Komorebic("stack left")
#Down::Komorebic("stack down")
#Up::Komorebic("stack up")
#Right::Komorebic("stack right")
#;::Komorebic("unstack")
#[::Komorebic("cycle-stack previous")
#]::Komorebic("cycle-stack next")
#Tab::Komorebic("cycle-stack next")
#+Tab::Komorebic("cycle-stack previous")

; Resize
#=::Komorebic("resize-axis horizontal increase")
#-::Komorebic("resize-axis horizontal decrease")
#+=::Komorebic("resize-axis vertical increase")
#+_::Komorebic("resize-axis vertical decrease")
#+WheelUp::Komorebic("resize-axis horizontal increase")
#+WheelDown::Komorebic("resize-axis horizontal decrease")
#+^WheelUp::Komorebic("resize-axis vertical increase")
#+^WheelDown::Komorebic("resize-axis vertical decrease")
#^WheelUp::Komorebic("resize-axis vertical increase")
#^WheelDown::Komorebic("resize-axis vertical decrease")

; Resize with mouse
#RButton::          ; Should be safe to change the modifier key as desired
{

    MouseGetPos , , &WindowID
    Winactivate(WindowID)
    ResizeWindow()
    KeyWait "RButton"
    Send "{LButton}"
}
#LButton::
{
    MouseGetPos , , &WindowID
    Winactivate(WindowID)
    WM_SYSCOMMAND := 0x0112                         ; This is a cleaner way to invoke the System Menu
    SC_MOVE := 0xF010                               ; than sending an Alt+Space followed by m.
    PostMessage WM_SYSCOMMAND, SC_MOVE, 0, , "A"    ; I like it.
    Send "{Down}"
    Keywait "LButton"
    Send "{LButton}"
}
ResizeWindow()  ; A little sum sum to hold us over until AltSnap is updated to work alongside Komorebi
{
    CoordMode "Mouse", "Window"
    MouseGetPos &CursorPinX, &CursorPinY, &WindowID
    WinGetPos &WindowPinX, &WindowPinY, &WindowWidth, &WindowHeight, WindowID

    Threshold := 0.25

    MouseRelX := CursorPinX / WindowWidth
    MouseRelY := CursorPinY / WindowHeight

    ; Note that WinGetPos returns the coordinates of the top-left corner of the specified window
    Left := ( ( CursorPinX ) / WindowWidth ) < ( Threshold )
    Right := ( ( CursorPinX ) / WindowWidth ) > ( 1.00 - Threshold )
    Top := ( ( CursorPinY ) / WindowHeight ) < ( Threshold )
    Bottom := ( ( CursorPinY ) / WindowHeight ) > ( 1.00 - Threshold )

    WM_SYSCOMMAND := 0x0112                         ; This is a cleaner way to invoke the System Menu
    SC_SIZE := 0xF000                               ; than sending an Alt+Space followed by s.
    PostMessage WM_SYSCOMMAND, SC_SIZE, 0, , "A"    ; I like it.

    If Left
    {
        Send "{Left}"
    }
    If Right
    {
        Send "{Right}"
    }
    If Top
    {
        Send "{Up}"
    }
    If Bottom
    {
        Send "{Down}"
    }

}

; Manipulate windows
#t::Komorebic("toggle-float")
#f::Komorebic("toggle-monocle")

; Window manager options
#+r::Komorebic("retile")
#p::Komorebic("toggle-pause")

; Layouts
#x::Komorebic("flip-layout horizontal")
#y::Komorebic("flip-layout vertical")
#Numpad0::Komorebic("toggle-tiling")
#Numpad4::Komorebic("cycle-layout previous")
#NumPad5::LayoutMenu.Show()
#`::LayoutMenu.Show()   ; This shows our menu instead of the PowerToys FancyZones Editor.
#Numpad6::Komorebic("cycle-layout next")

; Workspaces
#1::Komorebic("focus-workspace 0")
#2::Komorebic("focus-workspace 1")
#3::Komorebic("focus-workspace 2")
#4::Komorebic("focus-workspace 3")
#5::Komorebic("focus-workspace 4")
#6::Komorebic("focus-workspace 5")
#7::Komorebic("focus-workspace 6")
#8::Komorebic("focus-workspace 7")
#^h::komorebic("cycle-workspace previous")
#^left::komorebic("cycle-workspace previous")
#^l::komorebic("cycle-workspace next")
#^right::komorebic("cycle-workspace next")
#WheelUp::komorebic("cycle-workspace previous")
#WheelDown::Komorebic("cycle-workspace next")

; Move windows across workspaces
#+1::Komorebic("move-to-workspace 0")
#+2::Komorebic("move-to-workspace 1")
#+3::Komorebic("move-to-workspace 2")
#+4::Komorebic("move-to-workspace 3")
#+5::Komorebic("move-to-workspace 4")
#+6::Komorebic("move-to-workspace 5")
#+7::Komorebic("move-to-workspace 6")
#+8::Komorebic("move-to-workspace 7")
#+^h::komorebic("cycle-move-to-workspace previous")
#+^left::komorebic("cycle-move-to-workspace previous")
#+^l::komorebic("cycle-move-to-workspace next")
#+^right::komorebic("cycle-move-to-workspace next")

; Layout Selector Dialog {{{

LayoutMenu := Menu()
LayoutMenu.Add "1. BSP", ChangeLayout
LayoutMenu.Add "2. Columns", ChangeLayout
LayoutMenu.Add "3. Rows", ChangeLayout
LayoutMenu.Add "4. Vertical Stack", ChangeLayout
LayoutMenu.Add "5. Horizontal Stack", ChangeLayout
LayoutMenu.Add "6. Ultrawide Vertical Stack", ChangeLayout
LayoutMenu.Add "7. Grid", ChangeLayout
LayoutMenu.Add "8. Right Main Vertical Stack", ChangeLayout
LayoutMenu.Add "0. Toggle Tiling", ChangeLayout

ChangeLayout(Item, ItemPos, *) {
switch ItemPos {
    case 1: Komorebic("change-layout bsp")
    case 2: Komorebic("change-layout columns")
    case 3: Komorebic("change-layout rows")
    case 4: Komorebic("change-layout vertical-stack")
    case 5: Komorebic("change-layout horizontal-stack")
    case 6: Komorebic("change-layout ultrawide-vertical-stack")
    case 7: Komorebic("change-layout grid")
    case 8: Komorebic("change-layout right-main-vertical-stack")
    case 9: Komorebic("toggle-tiling")
}
}

; Layout Selector Dialog }}}

; Main binds to Komorebic }}}

; Windows Essentials {{{

; Functions used to Cycle/Launch Windows {{{

#e::cycle_windows('explorer.exe','CabinetWClass')
#+e::run('explorer')
#q::cycle_windows('wezterm-gui.exe','org.wezfurlong.wezterm')
#+q::run('wezterm-gui.exe')
; #q::cycle_windows('alacritty.exe','Window Class'," --working-directory " EnvGet("HOMEPATH"))
; #+q::run("alacritty --working-directory " EnvGet("HOMEPATH"))
#w::cycle_windows_exe_only('librewolf.exe',"`"C:\Program Files\LibreWolf\librewolf.exe`" -P")
#+w::Run("`"C:\Program Files\LibreWolf\librewolf.exe`" -P")

cycle_windows(exe,class,args:="") { ; {{{

    if WinActive('ahk_class' class) {           ; If the specified window is active, 
        WinActivateBottom('ahk_class' class)    ; move to bottom and 
        WinActivate('ahk_class' class)          ; focus the new highest rank window of specified ahk_class
    }

    if !WinExist('ahk_class' class) {       ; checks if an app is already running
        
        Run(exe args)                            ; IF NOT, open it.
        ,WinWait('ahk_class' class)         ; After opening, wait for it to open.
        WinActivate('ahk_class' class)      ; Bring it to the front and in focus.

        } else {
            WinActivate('ahk_class' class)  ; If the window of specified ahk_class exists then focus it.
        }
} ; }}}
cycle_windows_exe_only(prog,exe_path:=prog) { ; {{{
    ; note: exe_path is optional. By default, exe_path will just be the specified exe. This exe_path argument
    ;       can be left blank for cases when the executable of interest is in the PATH variable. If not, then
    ;       exe_path needs to be specified as the full path to the executable.
    exe := prog
    id := 'ahk_exe' exe

    ; If the specified window is active, move to bottom and focus the new highest rank window of specified ahk_class
    if WinActive(id) {
        WinActivateBottom(id)
        WinActivate(id)
    }
    
    ; checks if an app is already running
    if !WinExist(id) {
        
        Run(exe_path)                   ; IF window of specified exe does not exist then we launch it and 
        ,WinWait(id)                    ; wait for it to exist.

        WinActivate(id)                 ; Then we focus the window of specified exe.

        } else {
            WinActivate(id)             ; If the window of specified ahk_class already exists then focus it.
        }
} ; }}}
; Functions used to Cycle/Launch Windows }}}

; hjkl arrowing binds for Task Switcher and System Tray overflow items {{{
#HotIf WinActive("ahk_class XamlExplorerHostIslandWindow") or WinActive("ahk_class TopLevelWindowForOverflowXamlIsland")  
h::Send "{Left}"
l::Send "{Right}"
j::Send "{Down}"
k::Send "{Up}"
!h::Send "{blind}{Left}"                                    ; {blind} is required so AHK doesn't register ALT key being lifted.
!l::Send "{blind}{Right}"
!j::Send "{blind}{Down}"
!k::Send "{blind}{Up}"
a::Send "{Left}"
f::Send "{Right}"
s::Send "{Down}"
d::Send "{Up}"
!a::Send "{blind}{Left}"                                    ; {blind} is required so AHK doesn't register ALT key being lifted.
!f::Send "{blind}{Right}"
!s::Send "{blind}{Down}"
!d::Send "{blind}{Up}"
#HotIf ; }}}

#HotIf WinActive("ahk_exe PowerToys.PowerLauncher.exe")     ; Powertoys Run hjkl arrowing binds {{{
^h::Send "{Up}"
^j::Send "{Down}"
^k::Send "{Up}"
^l::Send "{Down}"
#HotIf  ; }}}

; Paste without formatting {{{
#HotIf !(A_Clipboard = "")  ; Add an exception if the Clipboard is empty.
^+v::                       ; With the exception set, we can hit ESC twice to clear the clipboard
{                           ; and still use FormatCopy/Paste with CTRL+SHIFT+C/V with Word's default binds.
A_Clipboard := A_Clipboard
send "^v"
}
#HotIf

; Clear the clipboard with Win-Del.
#Del::A_Clipboard := ""

; Paste without formatting }}}

; Toggle Taskbar (only works on main monitor) {{{
#F1::WinSetTransparent 255, "ahk_class Shell_TrayWnd"   ; Win+F1 to show taskbar 
#F2::WinSetTransparent 0, "ahk_class Shell_TrayWnd"     ; Win+F2 to hide taskbar

#HotIf !WinExist("ahk_class TopLevelWindowForOverflowXamlIsland")   ; Usually I like to have the taskbar hidden.
    ~#B::Send "{Space}"                                             ; Win-B is the standard shortcut to select the system tray overflow items.
#HotIf                                                              ; By pinning zero items other than wifi & such, we can get to our system tray apps with WIN-B
; Toggle Taskbar }}}

; NumLock/CapsLock/ScrollLock Indication {{{
~ScrollLock::SetTimer KeyStatus
~CapsLock::SetTimer KeyStatus
~NumLock::SetTimer KeyStatus

~Esc::          ; Set CAPS/NUM/SCROLL Lock key states back to what we like (CAPS off, SCROLL off, NUM on).
{
    if (A_PriorHotkey != "~Esc" or A_TimeSincePriorHotkey > 400)
    {
        ; Too much time between presses, so this isn't a double-press.
        KeyWait "Esc"
        return                      ; If prior hotkey is not ~Esc and time since is >400 ms
    }
                    				; If else (i.e., prior hotkey is ~Esc and time since is <400 ms we do the toggles
Send "{Esc}"
SetNumLockState True                ; Usually have Num Lock toggled on.
SetScrollLockState False            ; Usually have Scroll Lock toggled off.
SetCapsLockState False              ; Usually have Caps Lock toggled off.
; A_Clipboard := ""                 ; Empties the clipboard.
}

KeyStatus()
{
    Sleep 10
    msg := "" (GetKeyState("ScrollLock", "T") ? "Scroll Lock is ON`n" : "")
    msg := msg (GetKeyState("CapsLock", "T") ? "CAPS Lock is ON `n" : "")
    msg := msg (GetKeyState("Numlock", "T") ? "" : "NUM Lock is OFF")
    if (GetKeyState("ScrollLock", "T") or GetKeyState("CapsLock", "T") or !GetKeyState("NumLock", "T")) {
        ToolTip msg
    } else {
        ToolTip
    }
}
; NumLock/CapsLock/ScrollLock Indication }}}

; Windows Essentials }}}
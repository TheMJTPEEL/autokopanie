#NoEnv
#SingleInstance, Force

; wczytywanie ustawien 1
IniRead, bindgui, KopanieUstawienia.ini, Ustawienia, bindgui
IniRead, kilofy, KopanieUstawienia.ini, Ustawienia, kilofy
IniRead, title, KopanieUstawienia.ini, Ustawienia, title
IniRead, powiadom, KopanieUstawienia.ini, Ustawienia, powiadom
if BindGui
    hotkey, %BindGui%, bind, Off
    GuiControlGet, BindGui
if BindGui
    hotkey, %BindGui%, bind, on

; Gui
gui, show, w230 h240, AutoKopanie ; gui
gui, add, Text,, Podaj czas kopanie kilofa w sekundach ;czas
gui, add, Edit, w150 vczas Number
gui, add, Text,, Podaj Ilość Kilofów ;kilofy
gui, add, DropDownList, w150 vkilofy Choose10, 1|2|3|4|5|6|7|8|9|%kilofy%
gui, add, Text,, Wybierz Minecrafta ; list app
gui, add, DropDownList, w150 r8 vtitle Choose2, %list%|%title%
gui, add, Button, x+10, Odśwież ; odświezanie
gui, add, Text,xm , Podaj klawisz ;bind
gui, add, hotkey, w150 vbindgui, %bindgui%
gui, add, Checkbox, vpowiadom Checked%powiadom%,Powiadom po zakończeniu kopania ; powiadomienie
gui, add, Button,, Zapisz ; zapisz ustawienia
Gui show

; wczytywanie ustawien 2
IniRead, czas, KopanieUstawienia.ini, Ustawienia, czas
GuiControl,, czas, %czas%

; Lista aplikacji
WinGet, window_, List
Loop, %window_%{
    WinGetTitle,title,% "ahk_id" window_%A_Index%
    if(title)
    list.=title "|"
}
GuiControl,, title, %list%
gui, Submit, nohide
return

; kopanie
bind:
{   
    czasgui := czas * 1000
    klawisz := 1
    loop % kilofy
    {   
        ControlSend,, %klawisz%, %title%
        PostMessage, 0x201,,,, %title%
        sleep czasgui
        klawisz ++ 1
    }
    sleep czasgui
    PostMessage, 0x202,, %lParam%,, %title%
    klawisz = 1
    if (powiadom = 1){
        MsgBox, 64, AutoKopanie, Zakończono Kopanie
    }
    return
}

; Przyciski
ButtonOdśwież: ; odswiezanie listy programow
    list =
    WinGet, window_, List
    Loop, %window_%{
        WinGetTitle,title,% "ahk_id" window_%A_Index%
        if(title)
        list.=title "|"
    }
    GuiControl,, title, |%list%
    return

ButtonZapisz: ; zapisywanie w ini
    gui, Submit, nohide
    IniWrite, %czas%, KopanieUstawienia.ini, Ustawienia, czas
    IniWrite, %kilofy%, KopanieUstawienia.ini, Ustawienia, kilofy
    IniWrite, %title%, KopanieUstawienia.ini, Ustawienia, title
    IniWrite, %bindgui%, KopanieUstawienia.ini, Ustawienia, bindgui
    IniWrite, %powiadom%, KopanieUstawienia.ini, Ustawienia, powiadom
    if BindGui
        hotkey, %BindGui%, bind, Off
        GuiControlGet, BindGui
    if BindGui
        hotkey, %BindGui%, bind, on
    MsgBox, 64, AutoKopanie, Zapisano ustawienia
    gui, show
    return

GuiClose:
ExitApp
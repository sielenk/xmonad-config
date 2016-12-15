import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO


layout = Mirror tiled ||| tiled ||| Full
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 1
     ratio   = 3/4
     delta   = 3/100


conf = ewmh $ defaultConfig {
    terminal = "urxvtc",
    modMask = mod4Mask,
    manageHook = manageDocks <+> manageHook defaultConfig,
    layoutHook = avoidStruts  $  layout,
    handleEventHook = docksEventHook <+> handleEventHook defaultConfig
  }

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
  xmonad conf {
    startupHook = startupHook conf >> setWMName "LG3D",
    logHook = logHook conf >> dynamicLogWithPP xmobarPP {
      ppOutput = hPutStrLn xmproc,
      ppTitle = xmobarColor "green" "" . shorten 50
    }
  }

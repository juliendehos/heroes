
module App.Update where

import Miso
import Miso.Lens

import App.Action
import App.Model

updateModel :: Action -> Effect Model Action

updateModel (ActionChangeUri u) =
  modelUri .= u

updateModel (ActionHandleUri u) =
  io_ (pushURI u)

updateModel ActionPop =
  modelHeroes %= \case
    [] -> []
    (_:xs) -> xs


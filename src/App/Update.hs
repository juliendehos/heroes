
module App.Update where

import Miso
import Miso.Lens

import App.Action
import App.Model

updateModel :: Action -> Effect Model Action
updateModel = \case
  HandleURI u -> 
    modelUri .= u
  ChangeURI u -> 
    io_ (pushURI u)


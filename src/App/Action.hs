

module App.Action where

import Miso

--  Event Actions
data Action
    = ChangeURI URI
    | HandleURI URI
    deriving (Eq)


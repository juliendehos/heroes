
{-# LANGUAGE RecordWildCards #-}

module Heroes.Update where

import Miso

import Heroes.Action
import Heroes.Model

updateModel :: Action -> Effect Model Action
updateModel = \case
  HandleURI u ->
    modify $ \m -> m { uri = u }
  ChangeURI u -> do
    modify $ \m -> m { navMenuOpen = False }
    io_ (pushURI u)
  ToggleNavMenu -> do
    m@Model{..} <- get
    put m { navMenuOpen = not navMenuOpen }



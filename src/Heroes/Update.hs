
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module Heroes.Update where

import Data.Proxy
import Miso
import Servant.API
import Servant.Links

import Heroes.Model

-- | Event Actions
data Action
    = ChangeURI URI
    | HandleURI URI
    | ToggleNavMenu
    deriving (Show, Eq)

-- | Routes (server / client agnostic)
type Home a = a
type The404 a = "404" :> a
type Community a = "community" :> a

-- | Routes skeleton
type Routes a
  =    Home a
  :<|> Community a
  :<|> The404 a

-- | Client routing
type ClientRoutes = Routes (View Action)

-- | Links
uriHome, uriCommunity, uri404 :: URI
uriHome :<|> uriCommunity :<|> uri404 = 
  allLinks' linkURI (Proxy @ClientRoutes)

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



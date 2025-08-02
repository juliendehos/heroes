
module Heroes.Routes where

import Data.Proxy
import Miso
import Servant.API
import Servant.Links

import Heroes.Action

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


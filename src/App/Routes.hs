
module App.Routes where

import Data.Proxy
import Miso
import Miso.String (ms, MisoString)
import Servant.API
import Servant.Links

import App.Action (Action)
import App.Model (Model)

-- client/server routes
type RouteHome a = a
type RouteAbout a = "about" :> a
type Route404 a = "404" :> a

-- generic routes
type Routes a
  =    RouteHome a
  :<|> RouteAbout a
  :<|> Route404 a

-- define routes for client app
type ClientRoutes = Routes (View Model Action)

-- links to the routes
uriHome, uriAbout, uri404 :: URI
uriHome :<|> uriAbout :<|> uri404 = 
  allLinks' linkURI (Proxy @ClientRoutes)

uri2ms :: URI -> MisoString
uri2ms = ms . show


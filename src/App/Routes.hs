{-# LANGUAGE DataKinds #-}

module App.Routes where

import Data.Proxy
import Miso
import Miso.Router qualified as R
import Servant.API hiding (URI)
import Servant.Links hiding (URI)
import Servant.Miso.Router

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
uriHome, uriAbout, uri404 :: R.URI
uriHome :<|> uriAbout :<|> uri404 = 
  allLinks' toMisoURI (Proxy @ClientRoutes)

uri2ms :: URI -> MisoString   -- TODO
uri2ms = ms . show


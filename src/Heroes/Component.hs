
module Heroes.Component where

import Data.Proxy
import Servant.API
import Miso

import Heroes.Model
import Heroes.Routes
import Heroes.Update
import Heroes.View

-- | Component synonym
type HeroesComponent = Component Model Action

-- | Page for setting HTML doctype and header
newtype Page = Page HeroesComponent

-- | Client Handlers
clientHandlers
  ::   (Model -> View Action)
  :<|> (Model -> View Action)
  :<|> (Model -> View Action)
clientHandlers
  =    home
  :<|> community
  :<|> the404

heroesComponent :: URI -> HeroesComponent
heroesComponent uri =
  (componentApp uri)
    { subs = [ uriSub HandleURI ]
    , logLevel = DebugAll
    }

componentApp :: URI -> Component Model Action
componentApp currentUri = component emptyModel updateModel viewModel
  where
    emptyModel = Model currentUri False
    viewModel m =
        case route (Proxy :: Proxy ClientRoutes) clientHandlers uri m of
          Left _ -> the404 m
          Right v -> v


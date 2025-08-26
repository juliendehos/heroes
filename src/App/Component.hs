
module App.Component where

import Data.Proxy
import Servant.API
import Miso

import App.Action (Action(..))
import App.Model (Model(..), mkModel, modelUri)
import App.Routes (ClientRoutes)
import App.Update (updateModel)
import App.View (viewHome, viewAbout, view404)

type HeroesComponent = App Model Action

heroesComponent :: URI -> HeroesComponent
heroesComponent uri =
  (componentApp uri)
    { subs = [ uriSub ActionHandleUri ]
    , logLevel = DebugAll
    }

componentApp :: URI -> App Model Action
componentApp currentUri = component initialModel updateModel viewModel
  where
    initialModel = mkModel currentUri

    viewModel m =
        case route (Proxy @ClientRoutes) clientHandlers modelUri m of
          Left _ -> view404 m
          Right v -> v

    clientHandlers
      =    viewHome
      :<|> viewAbout
      :<|> view404


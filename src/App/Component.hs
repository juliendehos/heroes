
module App.Component where

import Data.Proxy
import Servant.API
import Miso

import App.Action
import App.Model
import App.Routes
import App.Update
import App.View

type HeroesComponent = Component Model Action

heroesComponent :: URI -> HeroesComponent
heroesComponent uri =
  (componentApp uri)
    { subs = [ uriSub HandleURI ]
    , logLevel = DebugAll
    }

componentApp :: URI -> Component Model Action
componentApp currentUri = component initialModel updateModel viewModel
  where
    initialModel = mkModel currentUri

    viewModel m =
        case route (Proxy @RoutesClient) routesHandlersClient _modelUri m of
          Left _ -> view404 m
          Right v -> v

routesHandlersClient
  =    viewHome
  :<|> viewAbout
  :<|> view404


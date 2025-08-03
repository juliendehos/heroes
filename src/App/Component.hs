-- TODO remove
{-# LANGUAGE OverloadedStrings #-}

module App.Component where

import Data.Proxy
import Servant.API
import Miso

import App.Action
import App.Model
import App.Routes
import App.Update
import App.View

-- TODO remove
import Domain.Hero

type HeroesComponent = Component Model Action

heroesComponent :: URI -> HeroesComponent
heroesComponent uri =
  (componentApp uri)
    { subs = [ uriSub ActionHandleUri ]
    , logLevel = DebugAll
    }

componentApp :: URI -> Component Model Action
componentApp currentUri = component initialModel updateModel viewModel
  where
    -- TODO initialModel = mkModel currentUri
    initialModel = Model heroes (Just "TODO") currentUri

    viewModel m =
        case route (Proxy @ClientRoutes) clientHandlers _modelUri m of
          Left _ -> view404 m
          Right v -> v

    clientHandlers
      =    viewHome
      :<|> viewAbout
      :<|> view404

    -- TODO remove
    heroes :: [Hero]
    heroes = 
        [ Hero "Scooby Doo" "scoobydoo.png"
        , Hero "Sponge Bob" "spongebob.png"
        ]



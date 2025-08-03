{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module App.View where

import Miso

import App.Action
import App.Model
import App.Routes
import Domain.Hero
import Server.Api

-- build a view, using a common template
mkView :: View Action -> View Action
mkView content =
  div_
    []
    [ p_ []
        [ button_ [ onClick (ActionChangeUri uriHome) ] [ "home" ]
        , button_ [ onClick (ActionChangeUri uriAbout) ] [ "about" ]
        ]
    , h1_ [] [ "Heroes" ]
    , content
    ]

viewAbout :: Model -> View Action
viewAbout _ = 
  mkView  $
    div_ 
      []
      [ h2_ [] [ "About" ]
      , p_ 
          []
          [ "Simple isomorphic web app using "
          , a_ [ href_ "https://github.com/dmjio/miso"] [ "Miso" ]
          , "."
          , br_ []
          , "See the "
          , a_ [ href_ "https://github.com/juliendehos/heroes"] [ "source code" ]
          , "."
          ]
      ]

viewHome :: Model -> View Action
viewHome Model{..} =
  mkView $
    div_ 
      []
      [ h2_ [] [ "Home" ]
      , p_ []
          [ button_ [ onClick (ActionChangeUri uriHome) ] [ "fetch" ]
          , button_ [ onClick ActionPop ] [ "pop" ]
          ]
      , ul_ [] (map fmtHero _modelHeroes)
      ]

  where
    fmtHero Hero{..} =
      li_ []
        [ text _heroName
        , br_ []
        , img_ [ src_ (mkStaticUri _heroImage) ]
        ]

view404 :: Model -> View Action
view404 _ =
  mkView  $
    div_
      []
      [ "page not found" ]


{-# LANGUAGE OverloadedStrings #-}

module App.View where

import Miso

import App.Action
import App.Model
import App.Routes
import Server.Api

-- build a view, using a common template
mkView :: View Action -> View Action
mkView content =
  div_
    []
    [ h1_ [] [ "Heroes" ]
    , content
    , p_ 
        []
        [ a_ 
            [ href_ "https://github.com/juliendehos/heroes"]
            [ "source code" ]
        ]
    ]

viewAbout :: Model -> View Action
viewAbout m = 
  mkView  $
    div_ 
      []
      [ h2_ [] [ "About" ]
      ]

viewHome :: Model -> View Action
viewHome m =
  mkView $
    div_ 
      []
      [ h2_ [] [ "Home" ]
      ]

view404 :: Model -> View Action
view404 m =
  mkView  $
    div_
      []
      [ "page not found" ]

-- TODO  a_ [href_ "/", onPreventClick (ChangeURI uriHome)] [text " - Go Home"]

{-
onPreventClick :: Action -> Attribute Action
onPreventClick action =
    onWithOptions
        defaultOptions{preventDefault = True}
        "click"
        emptyDecoder
        (\() -> const action)

-}


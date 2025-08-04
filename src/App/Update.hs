{-# LANGUAGE OverloadedStrings #-}

module App.Update where

import Miso
import Miso.Lens

import App.Action (Action(..))
import App.Model (Model, modelHeroes, modelError, modelUri)
import App.Routes (uri2ms)
import Server.Api (uriHeroes)

updateModel :: Action -> Transition Model Action

updateModel (ActionChangeUri u) = do
  modelUri .= u
  modelError .= ""

updateModel (ActionHandleUri u) = do
  io_ (pushURI u)
  modelError .= ""

updateModel ActionPopHeroes = do
  modelHeroes %= \case
    [] -> []
    (_:xs) -> xs
  modelError .= ""

updateModel (ActionError str) =
  modelError .= str

updateModel ActionFetchFail =
  fetch "fail" "GET" Nothing [] ActionSetHeroes ActionError

updateModel ActionFetchHeroes =
  fetch (uri2ms uriHeroes) "GET" Nothing [] ActionSetHeroes ActionError

updateModel (ActionSetHeroes heroes)  = do
  modelHeroes .= heroes
  modelError .= ""


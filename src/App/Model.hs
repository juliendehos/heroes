{-# LANGUAGE OverloadedStrings #-}

module App.Model where

import Miso
import Miso.Lens
import Miso.Lens.TH
import Miso.Router qualified as R -- TODO

import Domain.Hero (Hero)

data Model = Model
  { _modelHeroes :: [Hero]
  , _modelError :: MisoString
  , _modelUri :: R.URI
  } deriving (Eq)

makeLenses ''Model

mkModel :: URI -> Model
mkModel = Model [] " "    -- warning: an empty would cause hydration to fail


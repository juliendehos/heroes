
module App.Model where

import Miso
import Miso.Lens
import Miso.Lens.TH

import Domain.Hero

data Model = Model
  { _modelHeroes :: [Hero]
  , _modelUri :: URI
  } deriving (Eq)

makeLenses ''Model

mkModel :: URI -> Model
mkModel = Model []


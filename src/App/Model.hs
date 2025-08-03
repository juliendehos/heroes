
module App.Model where

import Miso
import Miso.Lens
import Miso.Lens.TH
import Miso.String

import Domain.Hero

data Model = Model
  { _modelHeroes :: [Hero]
  , _modelError :: Maybe MisoString
  , _modelUri :: URI
  } deriving (Eq)

makeLenses ''Model

mkModel :: URI -> Model
mkModel = Model [] Nothing


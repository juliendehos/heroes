
module Heroes.Model where

import Miso

data Model = Model
  { uri :: URI
  , navMenuOpen :: Bool
  } deriving (Eq)


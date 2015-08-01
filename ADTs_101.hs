
----------------------------------------------------
-- Introduction to Algebraic Datatypes in Haskell --
----------------------------------------------------

-- https://github.com/soenkehahn/ADTs_101

-- As an experiment this talk is using a Haskell
-- module and doctest. This hopefully allows for
-- an interactive talk.

module ADTs_101 where

-- $ >>> "Hello, " ++ "world"
-- "Hello, world!"


-- * Introduction

-- ADTs are a fundamental concept. More
-- fundamental than:
--
-- - type classes
-- - type class instances
-- - monads (!), functors
-- - monad transformers
-- - category theory
-- - arrows
-- - FRP
-- - parser combinators
-- - generic programming
-- - etc.

-- It's easy to get confused by the typical
-- learning materials for Haskell and think that
-- monads are a very fundamental concept. And they
-- are not irrelevant, but they are an advanced
-- topic. We should get a good grasp of ADTs
-- first.

-- Target audience: absolute beginners
-- Ambition: provide some additional intuition for
-- intermediate Haskellers


-- * Product Types

data Position
  = Position Int Int
  deriving (Show)

-- This datatype declaration creates a type
-- `Position` *and* a constructor `Position`.

-- A product type is a cartesian product of its
-- fields.

-- $ >>> Position 3 5
-- Position 3 5

-- $ >>> Position (3 + 5) 13
-- Position 8 13

-- A constructor is
--   - atomic
--   - *has* to be used to construct a value of
--     the type

mkPosition :: Int -> Position
mkPosition n = Position n n

-- $ >>> mkPosition 4
-- Position 4 4


-- * Implicit Signatures

-- Every datatype declaration introduces implicit
-- values with implicit types.

-- $ Constructors:
-- >>> :t Position
-- Position :: Int -> Int -> Position

-- Sometimes it's useful to bring them to mind.


-- * Selectors

data Position2 =
  Position2 {
    posX :: Int,
    posY :: Int
  }
  deriving (Show)

-- $ >>> posY (Position2 3 5)
-- 5

-- $ implicit signatures of selectors:
-- >>> :t posX
-- posX :: Position2 -> Int


-- * Deconstruction of Product Types

isValid :: Position -> Bool
isValid (Position x y) =
  x >= 1 && x <= 8 &&
  y >= 1 && y <= 8

-- $ >>> isValid (Position 3 5)
-- True
-- >>> isValid (Position 0 0)
-- False


-- * Sum Types

data Color
  = White
  | Black
  deriving (Show)

-- Sum types contain alternative constructors.

-- $ >>> White
-- White
-- >>> Black
-- Black

-- $ Again, implicit signatures:
-- >>> :t White
-- White :: Color
-- >>> :t Black
-- Black :: Color

-- One of the constructors *has* to be used to
-- construct a value of the type.


-- * Deconstruction of Sum Types

isBlack :: Color -> Bool
isBlack color = case color of
  Black -> True
  White -> False

-- $ >>> isBlack White
-- False


-- * Sum of Products

-- Every datatype is a combination of sum types
-- and product types.

data Piece
  = Pawn Position Color
  | Rook Position Color
  | Knight Position Color
  | Queen Position Color QueenOrigin
  -- ...
  deriving (Show)

data QueenOrigin
  = Original
  | Created
  deriving (Show)

-- $ implicit signatures again:
-- >>> :t Pawn
-- Pawn :: Position -> Color -> Piece
-- >>> :t Rook
-- Rook :: Position -> Color -> Piece
-- >>> :t Queen
-- Queen :: Position -> Color -> QueenOrigin -> Piece

-- We use our own datatypes as fields.

-- $ >>> Rook (mkPosition 1) Black
-- Rook (Position 1 1) Black


-- * Deconstruction

allowedMoves :: Piece -> [Position]
allowedMoves piece = case piece of
  Pawn (Position x y) color -> case color of
    White -> [Position x (y + 1)]
    Black -> [Position x (y - 1)]
  _ -> error "NYI"

-- $ >>> allowedMoves (Pawn (mkPosition 4) Black)
-- [Position 4 3]


-- * Random Thoughts

-- **
-- Don't model what you don't need!
-- Unused constructors / fields are dead code too!

-- **
-- Model your domain as closely as possible:
--   - Allow all possible values,
--   - try to disallow impossible values.

-- **
-- Designing good datatypes often requires some
-- experimentation. But don't worry: refactoring
-- is cheap in Haskell!

originalPositions :: Piece -> [Position]
originalPositions = undefined

-- **
-- Datatypes are cheap, use so-called throw-away
-- datatypes.

-- **
-- Some Combinatorics:
--   - wrappers
--   - enumerations
--   - unit types
--   - uninhabited types
--   - recursive datastructures

-- **
-- ghc give warnings about non-exhaustive
-- patterns.

-- **
-- Terminology: Where do the terms Sum Type and
-- Product Type come from?
--
--   - The number of possible values of a product
--     type is equal to the *product* of the
--     number of possible values of all fields.
--   - The number of possible values of a sum type
--     is equal to the *sum* of the possible
--     values for the type's constructors.

-- **
-- Record Update Syntax

data Board
  = Board {
    pieces :: [Piece]
  }
  deriving (Show)

emptyBoard :: Board
emptyBoard = Board []

-- $ >>> pieces emptyBoard
-- []
-- >>> emptyBoard{ pieces = [Pawn (Position 1 1) Black] }
-- Board {pieces = [Pawn (Position 1 1) Black]}

-- **
-- ADTs are very powerful. For that reason some
-- very basic types and language features are
-- implemented using ADTs:
--   - Bool
--   - Maybe
--   - Error handling (Either)
--   - lists (modulo syntactic sugar)
--   - other container types (Map, Set, etc.)


---------------------------
-- Thanks for listening! --
---------------------------
-- https://cdn.rawgit.com/mgajda/mentorship/master/session1.html
-- https://github.com/mgajda/ADTs_101

-- TUTORIAL session:
--
data Tree = Leaf Int
          | Branch { left, right :: Tree
	           , split :: Int }

-- 
insert :: Tree -> Int -> Tree
insert  = undefined

lookup :: Tree -> Int -> Bool
lookup  = undefined

-- Another version of lookup

-- A bit more difficult is to delete a node:
delete :: Tree -> Int -> Tree
delete  = undefined

data PTree a = PLeaf a
             | PBranch { pLeft, pRight :: Tree a
	               , pSplit :: a }

pLookup :: Tree a -> a -> Maybe a
pLookup  = undefined

-- $ >>> :t (<)
-- Ord a => a -> a -> Bool

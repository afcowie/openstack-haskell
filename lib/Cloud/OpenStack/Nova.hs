--
-- Embedding OpenStack in Haskell
--
-- Copyright © 2014-2015 Anchor Systems Pty Ltd
--
-- The code in this file, and the program it is a part of, is
-- made available to you by its authors as open source software:
-- you can redistribute it and/or modify it under the terms of
-- the 3-clause BSD licence.
--

{-# LANGUAGE DeriveFunctor #-}
{-# OPTIONS_HADDOCK hide, prune #-}

module Cloud.OpenStack.Nova
(
    ComputeOperation(..),
    listInstances,
    createServer,
    deleteServer,
    viaNova,
    fakeNova
)
where

import Control.Monad.Free
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as S
import Cloud.OpenStack.Internal


data ComputeOperation x = 
    = ListInstances (ByteString -> x)
    | CreateServer Hostname (ByteString -> x)
    | DeleteServer Instance x
    deriving Functor

-- FIXME `id` probably isn't the right function here. How do we create a list
-- of a concrete type? Presumably the answer is "the interpretation function
-- has to do the job" in which case `id` is fine. Or is the list going to mess
-- up the functor?
listInstances :: Free CloudOperation [Instance]
listInstances = liftF $ ListInstances id

createServer :: Hostname -> Free CloudOperation Instance
createServer hostname = liftF $ CreateServer hostname id

deleteServer :: Instance -> Free CloudOperation ()
deleteServer identifier = liftF $ DeleteServer identifier ()

{- form JSON request blob -}
{- use auth to create X-Auth-Token header and send via HTTP -}
{- parse response -}
viaNova :: MonadIO m => Token -> Free ComputeOperation a -> ExceptT CloudProblem m a
viaNova token operations =
  let
    endpoint = accessCompute token
    auth = accessTokenId token
  in
    liftIO $ interp operations
  where
    interp :: Free ComputeOperation a -> IO a
    interp (Pure x) = return x
    interp (Free x) = case x of
        ListInstances k -> do
                            result <- stuff1
                            interp (k result)
        CreateServer hostname k -> do
                            result <- stuff2
                            interp (k result)
        DeleteServer identifier k -> do
                            stuff3
                            interp k

    stuff :: IO a
    stuff = undefined

--
-- other interpreters
--

fakeNova :: Token -> Free ComputeOperation a -> ExceptT CloudProblem Identity a
fakeNova _ _ = undefined


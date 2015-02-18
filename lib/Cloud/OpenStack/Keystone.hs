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

{-# OPTIONS_HADDOCK hide, prune #-}

module Cloud.OpenStack.Keystone
(
    IdentOperation(..),
    viaKeystone,
    requestToken
)
where

import Control.Monad.Trans.Except
import Control.Monad.Free

import Cloud.OpenStack.Internal

data IdentOperation x
    = Authenticate x
    | ValidateToken x

--
-- | Given the published service entrypoint for an OpenStack cloud's keystone
-- identity service and credentials to access that cloud, get a token valid to
-- access various services within the specified tenancy.
--
requestToken :: Credentials -> URL -> IO Token
requestToken credentials endpoint = undefined

viaKeystone :: Token -> Free IdentOperation a -> ExceptT CloudProblem m a
viaKeystone = undefined



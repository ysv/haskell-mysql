{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_lab1 (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [1,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/yaroslavsavchuk/Developer/ysv/my-haskell-sql/.stack-work/install/x86_64-osx/lts-13.8/8.6.3/bin"
libdir     = "/Users/yaroslavsavchuk/Developer/ysv/my-haskell-sql/.stack-work/install/x86_64-osx/lts-13.8/8.6.3/lib/x86_64-osx-ghc-8.6.3/lab1-1.0-2Mm9hZpBuuAIYbbhJTkkHJ-lab1"
dynlibdir  = "/Users/yaroslavsavchuk/Developer/ysv/my-haskell-sql/.stack-work/install/x86_64-osx/lts-13.8/8.6.3/lib/x86_64-osx-ghc-8.6.3"
datadir    = "/Users/yaroslavsavchuk/Developer/ysv/my-haskell-sql/.stack-work/install/x86_64-osx/lts-13.8/8.6.3/share/x86_64-osx-ghc-8.6.3/lab1-1.0"
libexecdir = "/Users/yaroslavsavchuk/Developer/ysv/my-haskell-sql/.stack-work/install/x86_64-osx/lts-13.8/8.6.3/libexec/x86_64-osx-ghc-8.6.3/lab1-1.0"
sysconfdir = "/Users/yaroslavsavchuk/Developer/ysv/my-haskell-sql/.stack-work/install/x86_64-osx/lts-13.8/8.6.3/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "lab1_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "lab1_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "lab1_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "lab1_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "lab1_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "lab1_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)

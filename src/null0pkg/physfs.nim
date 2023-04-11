# simplified physfs

# ideas from https://github.com/fowlmouth/physfs
# see here for more ideas: https://github.com/treeform/staticglfw/blob/master/src/staticglfw.nim#L4-L88

{.emit: """
#define PHYSFS_SUPPORTS_ZIP 1
""".}

{.compile: "vendor/physfs/src/physfs.c".}
{.compile: "vendor/physfs/src/physfs_byteorder.c".}
{.compile: "vendor/physfs/src/physfs_unicode.c".}
{.compile: "vendor/physfs/src/physfs_platform_posix.c".}
{.compile: "vendor/physfs/src/physfs_platform_unix.c".}
{.compile: "vendor/physfs/src/physfs_platform_windows.c".}
{.compile: "vendor/physfs/src/physfs_platform_os2.c".}
{.compile: "vendor/physfs/src/physfs_platform_qnx.c".}
{.compile: "vendor/physfs/src/physfs_platform_android.c".}

when defined(macosx):
  {.compile: "vendor/physfs/src/physfs_platform_apple.m".}
  {.passL: "-framework IOKit -framework Foundation".}

when defined(linux):
  {.passL: "-lpthread".}

# TODO: probly need some platform-specific stuff for windows

{.compile: "vendor/physfs/src/physfs_archiver_dir.c".}
{.compile: "vendor/physfs/src/physfs_archiver_zip.c".}
{.compile: "vendor/physfs/src/physfs_archiver_unpacked.c".}
{.compile: "vendor/physfs/src/physfs_archiver_grp.c".}
{.compile: "vendor/physfs/src/physfs_archiver_hog.c".}
{.compile: "vendor/physfs/src/physfs_archiver_7z.c".}
{.compile: "vendor/physfs/src/physfs_archiver_mvl.c".}
{.compile: "vendor/physfs/src/physfs_archiver_qpak.c".}
{.compile: "vendor/physfs/src/physfs_archiver_wad.c".}
{.compile: "vendor/physfs/src/physfs_archiver_slb.c".}
{.compile: "vendor/physfs/src/physfs_archiver_iso9660.c".}
{.compile: "vendor/physfs/src/physfs_archiver_vdf.c".}



import std/options

type 
  PHYSFS_File* {.pure, final.} = object 
    opaque: pointer

{.push callconv: cdecl, importc:"PHYSFS_$1".}
proc init*(name: cstring): cint
proc deinit*(): cint
proc mount*(newDir: cstring, mountPoint: cstring, appendToPath:cint): cint
proc openRead*(filename: cstring): ptr PHYSFS_File
proc exists*(name: cstring): int
proc close*(handle: ptr PHYSFS_File): void
proc fileLength*(handle: ptr PHYSFS_File): int64
proc readBytes*(handle: ptr PHYSFS_File, buffer: pointer, len: uint64): int64
proc writeBytes*(handle: ptr PHYSFS_File, buffer: pointer, len: uint64): int64
proc mountMemory*(buff: pointer, length:int64, del:Option[pointer], newDir:cstring, mountPoint:cstring, appendToPath:cint): cint
{.pop.}

## helpers

proc readFilePhysfs*(filepath: string): string =
  if exists(filepath) != 1:
      raise newException(IOError, filepath & " does not exist.")
  let f = openRead(filepath)
  let l = uint64 fileLength(f)
  let outBytes = newString(l)
  var bytesRead = uint64 readBytes(f, unsafeAddr outBytes[0], l)
  if bytesRead != l:
    raise newException(IOError, "Could not read " & filepath)
  close(f)
  return outBytes

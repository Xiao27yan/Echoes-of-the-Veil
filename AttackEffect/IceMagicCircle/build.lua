local spr = Sprite(128, 128, ColorMode.RGB)
spr.filename = 'AttackEffect/IceMagicCircle/IceMagicCircle.aseprite'
local layer = spr:newLayer()
layer.name = 'Ice Sigil'
local files = {
 'AttackEffect/IceMagicCircle/frame01.png',
 'AttackEffect/IceMagicCircle/frame02.png',
 'AttackEffect/IceMagicCircle/frame03.png',
 'AttackEffect/IceMagicCircle/frame04.png',
 'AttackEffect/IceMagicCircle/frame05.png',
 'AttackEffect/IceMagicCircle/frame06.png',
 'AttackEffect/IceMagicCircle/frame07.png',
 'AttackEffect/IceMagicCircle/frame08.png'
}
for i, path in ipairs(files) do
  local image = Image{ fromFile = path }
  local frame = (i == 1) and spr.frames[1] or spr:newFrame()
  frame.duration = (i == 3 or i == 4 or i == 5) and 120 or 90
  local cel = spr:newCel(layer, frame, image, Point(0, 0))
end
local tag = spr:newTag(1, #files)
tag.name = 'Cast'
tag.aniDir = AniDir.FORWARD
spr:saveAs(spr.filename)

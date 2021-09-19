# tag-block-aggregator.{sh,awk}

Aggregates content based on tag and content block, as described in [Zim Wiki issue 1590](https://github.com/zim-desktop-wiki/zim-desktop-wiki/issues/1590) with the addition of a space between "tag:" and the tags. See Examples below to see what that looks like.

## Usage

### Adding as custom tool

- [Command] `tag-block-aggregator.sh %n Journal %t`
- [x] Command does not modify data
- [x] Output should replace current selection

If you want to aggregate content from somewhere else than `%n/Journal`, edit the command accordingly.

### Tag block syntax

This implementation supports multiple tags per "tag line", and content blocks can be stacked inside one another.

Tag blocks begin with

    tag: TAG1 [TAG2..] --

and end with either

    end: TAG1 [TAG2..] --

which ends the listed tags, or

    --

which ends all blocks.

`tag` is considered equal to `@tag` - you don't need to type the `@` when aggregating.

### Aggregating

1. Type the tag (without `@`) which you want to aggregate
2. Move the cursor over the tag
3. Trigger the Custom Tool

## Examples

A header with a link to the source page is added before the its first block's contents. Subsequent blocks with the same tag are separated by a divider. These shouldn't be too hard to change to fit to taste ;)

The source Journal pages are shown below the examples. Formatting is just text and thus carried over, but attachments break. This can be worked around by storing your attachments outside the notebook and using absolute links.

### Aggregating `homedesign`

```
=== [[:Journal:2021:09:18]] ===
content
=== [[:Journal:2021:09:19]] ===
content here
-----
this one is inside some other ones

```

### Aggregating `test`

```
=== [[:Journal:2021:09:19]] ===
first content
-----
multiple tags!
also, here's a homedesign block:
this one is inside some other ones
this is outside home design,
but still inside plural && @test
-----
here starts a @test tag
-----
with another inside
-----
and a third
now depth should be 2
```

### Aggregating `ending`

Separators are applied only for blocks with the `search_tag`.

```
=== [[:Journal:2021:09:19]] ===
here starts a @test tag
with another inside
and a third
now depth should be 2
```

### Journal pages as used for the above
Journal:2021:09:18
```
Totes a journal page

tag: homedesign --
content
--
not content
```

Journal:2021:09:19
```
This is a page

tag: @test --
first content
--

tag: homedesign --
content here
--
not content

tag: plural @test --
multiple tags!
also, here's a homedesign block:
tag: homedesign --
this one is inside some other ones
end: homedesign --
this is outside home design,
but still inside plural && @test
--

tag: ending @test --
here starts a @test tag
tag: @test --
with another inside
tag: @test --
and a third
end: @test --
now depth should be 2
--
this isn't content

more non-content

```

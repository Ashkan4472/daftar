#!/usr/bin/env python3
"""Draws the Daftar logo set into assets/brand/. Run: python3 tool/make_brand.py"""
from PIL import Image, ImageDraw, ImageFilter
import os

OUT = os.path.join(os.path.dirname(__file__), '..', 'assets', 'brand')
os.makedirs(OUT, exist_ok=True)
S = 4  # supersample
N = 1024 * S


def gradient(size):
    # diagonal blue gradient, top-left lighter
    a, b = (37, 99, 235), (30, 58, 138)
    img = Image.new('RGB', (size, size))
    px = img.load()
    # cheap: build a 1px-per-step gradient and shear it
    for y in range(size):
        for x in range(0, size):
            t = (x + y) / (2 * size)
            px[x, y] = tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))
    return img


def notebook(d: ImageDraw.ImageDraw, scale: float, shadow_layer=None):
    cx = cy = N // 2
    w, h = int(460 * S * scale), int(540 * S * scale)
    x0, y0 = cx - w // 2, cy - h // 2
    x1, y1 = x0 + w, y0 + h
    r = int(56 * S * scale)
    u = S * scale
    if shadow_layer is not None:
        sd = ImageDraw.Draw(shadow_layer)
        sd.rounded_rectangle((x0, y0 + 24 * u, x1, y1 + 24 * u), r, fill=(8, 20, 70, 110))
    d.rounded_rectangle((x0, y0, x1, y1), r, fill=(255, 255, 255, 255))
    # spine
    # spine: clipped to the page outline so no corner pixels leak outside it
    mask = Image.new('L', (N, N), 0)
    ImageDraw.Draw(mask).rounded_rectangle((x0, y0, x1, y1), r, fill=255)
    spine = Image.new('RGBA', (N, N), (0, 0, 0, 0))
    ImageDraw.Draw(spine).rectangle((x0, y0, x0 + 84 * u, y1), fill=(191, 219, 254, 255))
    d._image.paste(spine, (0, 0), Image.composite(spine.split()[3], Image.new('L', (N, N), 0), mask))
    for i in range(4):  # binding dots
        yy = y0 + (90 + i * 120) * u
        d.ellipse((x0 + 30 * u, yy, x0 + 54 * u, yy + 24 * u), fill=(30, 64, 175, 255))
    # ledger lines
    blue = (30, 64, 175, 255)
    for i, length in enumerate([300, 300, 300, 190]):
        yy = y0 + (185 + i * 92) * u
        d.rounded_rectangle((x0 + 130 * u, yy, x0 + (130 + length) * u, yy + 30 * u), 15 * u, fill=blue if i < 3 else blue)
    # green coin on the last line
    gx, gy = x0 + 365 * u, y0 + (185 + 3 * 92 + 15) * u
    d.ellipse((gx - 30 * u, gy - 30 * u, gx + 30 * u, gy + 30 * u), fill=(16, 185, 129, 255))
    # bookmark ribbon
    d.polygon([(x1 - 120 * u, y0), (x1 - 50 * u, y0), (x1 - 50 * u, y0 + 120 * u), (x1 - 85 * u, y0 + 88 * u), (x1 - 120 * u, y0 + 120 * u)], fill=(16, 185, 129, 255))


def render(scale, background):
    base = gradient(N // 4).resize((N, N), Image.BICUBIC).convert('RGBA') if background else Image.new('RGBA', (N, N), (0, 0, 0, 0))
    shadow = Image.new('RGBA', (N, N), (0, 0, 0, 0))
    layer = Image.new('RGBA', (N, N), (0, 0, 0, 0))
    notebook(ImageDraw.Draw(layer), scale, shadow)
    shadow = shadow.filter(ImageFilter.GaussianBlur(18 * S))
    base.alpha_composite(shadow)
    base.alpha_composite(layer)
    return base


def rounded(img, radius_frac=0.22):
    mask = Image.new('L', img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, img.size[0], img.size[1]), int(img.size[0] * radius_frac), fill=255)
    out = Image.new('RGBA', img.size, (0, 0, 0, 0))
    out.paste(img, (0, 0), mask)
    return out


full = render(1.25, True)
full.convert('RGB').resize((1024, 1024), Image.LANCZOS).save(os.path.join(OUT, 'icon.png'))
render(0.9, False).resize((1024, 1024), Image.LANCZOS).save(os.path.join(OUT, 'icon_foreground.png'))
rounded(full).resize((768, 768), Image.LANCZOS).save(os.path.join(OUT, 'splash_logo.png'))
rounded(full).resize((512, 512), Image.LANCZOS).save(os.path.join(OUT, 'logo.png'))
print('ok')

---
title: Microsoft Office
---

## PowerPoint

* Export a presentation as PDF with (custom) fonts embedded: PowerPoint is terrible at this. There are a bunch of checkboxes in various places you can tick but even with all of those and using SIL OFL fonts (that are definitely embeddable), PowerPoint tends to refuse to embed them. There are two working ways I know of:
    * If you have an Acrobat subscription, use the *Save as Adobe PDF* feature from the (automatically installed) Acrobat addon. That produces nice PDFs with proper embedded fonts. In the save dialog, click *Options* and make sure that *Create PDF/A-1a:2005 compliant file* is checked and *Preserve Slide Transitions* is unchecked (otherwise, you'll get horrible over-the-top slide transistions when viewing the PDF in Acrobat Reader). You can set those as defaults by going to the *Acrobat* tab and *Preferences*.
    * Otherwise, a two-step approach is needed. First, import a PDF without embedded fonts using *File* -> *Export* -> *Create PDF/XPS document* -> *Create PDF/XPS*. In the save dialog, click *Options* and make sure that under *PDF options*, *PDF/A compliant* and *Bitmap text when fonts may not be embedded* are both unchecked (otherwise, it will likely produce a PDF where every slide is rasterized). Then, [use `pdftocairo` to embed the fonts](/reference/linux#poppler). The resulting PDF will unfortunately not be PDF/a compliant.

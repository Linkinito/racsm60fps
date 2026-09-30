#!/usr/bin/env python3
"""Minimal dependency-free XLSX and PDF writers (thread reporting tools).

Both writers are intentionally small and self-contained so the reports can be
regenerated on a machine with nothing but CPython:

  write_xlsx(path, sheets)   sheets = [(name, rows, opts)] with rows = list of
                             lists (str / int / float / None). opts: {'widths':
                             [...], 'freeze': True, 'bold_first_row': True}
  PdfDoc()                   page-oriented PDF writer: heading(), para(),
                             mono_table(), spacer(), bullet(); save(path)

The PDF uses the base-14 fonts (Helvetica, Helvetica-Bold, Courier) with
WinAnsiEncoding, so French accents work without embedding anything.
"""

import os
import zipfile

# --------------------------------------------------------------------------
# XLSX
# --------------------------------------------------------------------------

CONTENT_TYPES = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
{sheet_overrides}
</Types>"""

ROOT_RELS = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>"""

STYLES = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
<fonts count="2">
<font><sz val="11"/><name val="Calibri"/></font>
<font><b/><sz val="11"/><name val="Calibri"/></font>
</fonts>
<fills count="2"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill></fills>
<borders count="1"><border/></borders>
<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
<cellXfs count="2">
<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>
<xf numFmtId="0" fontId="1" fillId="0" borderId="0" xfId="0" applyFont="1"/>
</cellXfs>
</styleSheet>"""


def _col_name(index):
    name = ''
    index += 1
    while index:
        index, rem = divmod(index - 1, 26)
        name = chr(65 + rem) + name
    return name


def _escape(text):
    text = str(text)
    out = []
    for ch in text:
        if ch in '&<>':
            out.append({'&': '&amp;', '<': '&lt;', '>': '&gt;'}[ch])
        elif ord(ch) < 32:
            out.append(' ')
        else:
            out.append(ch)
    return ''.join(out)


def _cell(ref, value, style):
    attr = ' s="%d"' % style if style else ''
    if value is None or value == '':
        return '<c r="%s"%s/>' % (ref, attr)
    if isinstance(value, (int, float)) and not isinstance(value, bool):
        return '<c r="%s"%s><v>%s</v></c>' % (ref, attr, repr(value))
    return ('<c r="%s"%s t="inlineStr"><is><t xml:space="preserve">%s</t></is></c>'
            % (ref, attr, _escape(value)))


def _sheet_xml(rows, opts):
    widths = opts.get('widths') or []
    freeze = opts.get('freeze', True)
    bold_first = opts.get('bold_first_row', True)
    cols = ''
    if widths:
        cols = '<cols>' + ''.join(
            '<col min="%d" max="%d" width="%s" customWidth="1"/>' % (i + 1, i + 1, w)
            for i, w in enumerate(widths)) + '</cols>'
    view = ''
    if freeze:
        view = ('<sheetViews><sheetView workbookViewId="0">'
                '<pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/>'
                '</sheetView></sheetViews>')
    body = []
    for r, row in enumerate(rows, 1):
        cells = []
        for c, value in enumerate(row):
            style = 1 if (r == 1 and bold_first) else 0
            cells.append(_cell('%s%d' % (_col_name(c), r), value, style))
        body.append('<row r="%d">%s</row>' % (r, ''.join(cells)))
    dimension = 'A1:%s%d' % (_col_name(max(len(r) for r in rows) - 1), len(rows)) \
        if rows else 'A1'
    return ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
            '<dimension ref="%s"/>%s%s<sheetData>%s</sheetData></worksheet>'
            % (dimension, view, cols, ''.join(body)))


def write_xlsx(path, sheets):
    """sheets: list of (name, rows, opts). Overwrites path."""
    overrides = '\n'.join(
        '<Override PartName="/xl/worksheets/sheet%d.xml" '
        'ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
        % (i + 1) for i in range(len(sheets)))
    workbook_sheets = ''.join(
        '<sheet name="%s" sheetId="%d" r:id="rId%d"/>' % (_escape(n)[:31], i + 1, i + 1)
        for i, (n, _rows, _opts) in enumerate(sheets))
    workbook = ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
                '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
                'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
                '<sheets>%s</sheets></workbook>' % workbook_sheets)
    rels = ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
            + ''.join('<Relationship Id="rId%d" Type="http://schemas.openxmlformats.org/'
                      'officeDocument/2006/relationships/worksheet" Target="worksheets/sheet%d.xml"/>'
                      % (i + 1, i + 1) for i in range(len(sheets)))
            + '<Relationship Id="rId%d" Type="http://schemas.openxmlformats.org/officeDocument/'
              '2006/relationships/styles" Target="styles.xml"/>' % (len(sheets) + 1)
            + '</Relationships>')
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED) as zf:
        zf.writestr('[Content_Types].xml', CONTENT_TYPES.format(sheet_overrides=overrides))
        zf.writestr('_rels/.rels', ROOT_RELS)
        zf.writestr('xl/workbook.xml', workbook)
        zf.writestr('xl/_rels/workbook.xml.rels', rels)
        zf.writestr('xl/styles.xml', STYLES)
        for i, (_name, rows, opts) in enumerate(sheets):
            zf.writestr('xl/worksheets/sheet%d.xml' % (i + 1), _sheet_xml(rows, opts))
    return path


# --------------------------------------------------------------------------
# PDF
# --------------------------------------------------------------------------

A4 = (595.28, 841.89)
MARGIN = 46.0


def _pdf_escape(text):
    """WinAnsi bytes with PDF string escapes (French accents included)."""
    out = []
    for ch in str(text):
        code = ord(ch)
        if ch in '()\\':
            out.append('\\' + ch)
        elif code < 32:
            out.append(' ')
        elif code < 127:
            out.append(ch)
        else:
            out.append('\\%03o' % (code & 0xFF if code < 256 else ord('?')))
    return ''.join(out)


class PdfDoc(object):
    """Page-oriented PDF writer using the base-14 fonts."""

    def __init__(self, title='', footer_left=''):
        self.title = title
        self.footer_left = footer_left
        self.pages = []
        self._new_page()

    def _new_page(self):
        self.ops = []
        self.y = A4[1] - MARGIN
        self.pages.append(self.ops)

    def _space(self, needed):
        if self.y - needed < MARGIN + 18:
            self._new_page()

    def _text(self, x, text, font='F1', size=10.5, color=None):
        self.ops.append('BT /%s %.2f Tf %.2f %.2f Td (%s) Tj ET'
                        % (font, size, x, self.y, _pdf_escape(text)))

    def heading(self, text, size=16, font='F2'):
        self._space(size * 2.2)
        self._text(MARGIN, text, font, size)
        self.y -= size * 1.35
        self.ops.append('%.2f %.2f m %.2f %.2f l S'
                        % (MARGIN, self.y + 4, A4[0] - MARGIN, self.y + 4))
        self.y -= 8

    def subheading(self, text, size=12, font='F2'):
        self._space(size * 2.4)
        self._text(MARGIN, text, font, size)
        self.y -= size * 1.45

    def para(self, text, size=10.5, font='F1', indent=0.0, width=None):
        width = width or (A4[0] - 2 * MARGIN - indent)
        line = ''
        for word in str(text).split(' '):
            probe = (line + ' ' + word).strip()
            if len(probe) * size * 0.50 > width and line:
                self._space(size * 1.6)
                self._text(MARGIN + indent, line, font, size)
                self.y -= size * 1.45
                line = word
            else:
                line = probe
        if line:
            self._space(size * 1.6)
            self._text(MARGIN + indent, line, font, size)
            self.y -= size * 1.45

    def bullet(self, text, size=10.5):
        self._space(size * 1.7)
        self._text(MARGIN, '-', 'F1', size)
        self.para(text, size=size, indent=12)

    def mono_table(self, header, rows, size=8.0, widths=None, max_rows=None):
        """Fixed-width table in Courier; widths in characters."""
        widths = widths or [max(len(str(header[i])), *(len(str(r[i])) for r in rows))
                            for i in range(len(header))]
        widths = [min(w, 60) for w in widths]
        line_height = size * 1.32
        char_w = size * 0.60

        def emit(values, font):
            self._space(line_height)
            x = MARGIN
            for value, width in zip(values, widths):
                text = str(value)
                if len(text) > width:
                    text = text[:width - 1] + '.'
                self._text(x, text.ljust(width), font, size)
                x += (width + 1) * char_w
            self.y -= line_height

        emit(header, 'F2')
        for row in rows if max_rows is None else rows[:max_rows]:
            emit(row, 'F3')
        if max_rows is not None and len(rows) > max_rows:
            self.para('... %d ligne(s) supplementaire(s) - voir le XLSX.' % (len(rows) - max_rows),
                      size=9)

    def spacer(self, height=8.0):
        self.y -= height

    def key_values(self, pairs, size=10.5, label_width=34):
        for key, value in pairs:
            self._space(size * 1.7)
            self._text(MARGIN, ('%s' % key).ljust(label_width)[:label_width], 'F2', size)
            self._text(MARGIN + label_width * size * 0.52, str(value), 'F1', size)
            self.y -= size * 1.5

    def save(self, path):
        objects = []
        page_count = len(self.pages)
        kids = ' '.join('%d 0 R' % (4 + 2 * i) for i in range(page_count))
        objects.append('<< /Type /Catalog /Pages 2 0 R >>')
        objects.append('<< /Type /Pages /Kids [%s] /Count %d >>' % (kids, page_count))
        objects.append('<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica '
                       '/Encoding /WinAnsiEncoding >>')
        objects.append('<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold '
                       '/Encoding /WinAnsiEncoding >>')
        objects.append('<< /Type /Font /Subtype /Type1 /BaseFont /Courier '
                       '/Encoding /WinAnsiEncoding >>')
        font_refs = ' '.join('%d 0 R' % (i + 3) for i in range(3))
        page_ids = []
        contents = []
        for page_index, ops in enumerate(self.pages):
            page_id = 6 + 2 * page_index
            content_id = page_id + 1
            page_ids.append(page_id)
            body = list(ops)
            if self.footer_left:
                body.append('BT /F1 8 Tf %.2f %.2f Td (%s) Tj ET'
                            % (MARGIN, 24, _pdf_escape(self.footer_left)))
            body.append('BT /F1 8 Tf %.2f %.2f Td (page %d / %d) Tj ET'
                        % (A4[0] - MARGIN - 60, 24, page_index + 1, page_count))
            contents.append(chr(10).join(body))
        for page_index in range(page_count):
            page_id = 6 + 2 * page_index
            objects.append('<< /Type /Page /Parent 2 0 R /MediaBox [0 0 %.2f %.2f] '
                           '/Resources << /Font << /F1 %d 0 R /F2 %d 0 R /F3 %d 0 R >> >> '
                           '/Contents %d 0 R >>'
                           % (A4[0], A4[1], 3, 4, 5, page_id + 1))
            stream = contents[page_index]
            objects.append('<< /Length %d >>\nstream\n%s\nendstream' % (len(stream), stream))
        out = bytearray(b'%PDF-1.4\n')
        offsets = []
        for index, body in enumerate(objects, 1):
            offsets.append(len(out))
            out += ('%d 0 obj\n%s\nendobj\n' % (index, body)).encode('latin-1')
        xref_at = len(out)
        out += ('xref\n0 %d\n' % (len(objects) + 1)).encode('latin-1')
        out += b'0000000000 65535 f \n'
        for offset in offsets:
            out += ('%010d 00000 n \n' % offset).encode('latin-1')
        out += ('trailer\n<< /Size %d /Root 1 0 R /Info << /Title (%s) >> >>\n'
                'startxref\n%d\n%%%%EOF\n'
                % (len(objects) + 1, _pdf_escape(self.title), xref_at)).encode('latin-1')
        with open(path, 'wb') as handle:
            handle.write(bytes(out))
        return path

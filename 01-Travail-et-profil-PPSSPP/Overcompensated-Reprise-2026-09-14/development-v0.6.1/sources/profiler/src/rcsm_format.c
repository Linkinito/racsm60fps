#include "rcsm_format.h"

#include <stdint.h>

typedef struct RcsmTextBuffer {
    char *data;
    size_t capacity;
    size_t length;
} RcsmTextBuffer;

static void text_putc(RcsmTextBuffer *buffer, char value) {
    if (buffer->length + 1u < buffer->capacity) {
        buffer->data[buffer->length++] = value;
    }
}

static void text_puts(RcsmTextBuffer *buffer, const char *value) {
    if (value == NULL) {
        value = "(null)";
    }
    while (*value != '\0') {
        text_putc(buffer, *value++);
    }
}

static void text_put_u32(RcsmTextBuffer *buffer, uint32_t value, unsigned base, unsigned width, char pad) {
    static const char digits[] = "0123456789ABCDEF";
    char reversed[16];
    unsigned count = 0u;
    do {
        reversed[count++] = digits[value % base];
        value /= base;
    } while (value != 0u && count < sizeof(reversed));
    while (count < width) {
        text_putc(buffer, pad);
        --width;
    }
    while (count != 0u) {
        text_putc(buffer, reversed[--count]);
    }
}

static void text_put_i32(RcsmTextBuffer *buffer, int32_t value, unsigned width, char pad) {
    uint32_t magnitude;
    if (value < 0) {
        text_putc(buffer, '-');
        if (width > 0u) {
            --width;
        }
        magnitude = (uint32_t)(-(value + 1)) + 1u;
    } else {
        magnitude = (uint32_t)value;
    }
    text_put_u32(buffer, magnitude, 10u, width, pad);
}

size_t rcsm_vformat(char *destination, size_t capacity, const char *format, va_list args) {
    RcsmTextBuffer buffer = {destination, capacity, 0u};
    if (destination == NULL || capacity == 0u || format == NULL) {
        return 0u;
    }
    while (*format != '\0') {
        unsigned width = 0u;
        char pad = ' ';
        if (*format != '%') {
            text_putc(&buffer, *format++);
            continue;
        }
        ++format;
        if (*format == '%') {
            text_putc(&buffer, *format++);
            continue;
        }
        if (*format == '0') {
            pad = '0';
            ++format;
        }
        while (*format >= '0' && *format <= '9') {
            if (width < 1000u) {
                width = width * 10u + (unsigned)(*format - '0');
            }
            ++format;
        }
        if (*format == 's') {
            text_puts(&buffer, va_arg(args, const char *));
        } else if (*format == 'd') {
            text_put_i32(&buffer, va_arg(args, int), width, pad);
        } else if (*format == 'u') {
            text_put_u32(&buffer, va_arg(args, unsigned), 10u, width, pad);
        } else if (*format == 'X') {
            text_put_u32(&buffer, va_arg(args, unsigned), 16u, width, pad);
        } else {
            text_putc(&buffer, '?');
        }
        if (*format != '\0') {
            ++format;
        }
    }
    buffer.data[buffer.length] = '\0';
    return buffer.length;
}

size_t rcsm_format(char *destination, size_t capacity, const char *format, ...) {
    size_t length;
    va_list args;
    va_start(args, format);
    length = rcsm_vformat(destination, capacity, format, args);
    va_end(args);
    return length;
}

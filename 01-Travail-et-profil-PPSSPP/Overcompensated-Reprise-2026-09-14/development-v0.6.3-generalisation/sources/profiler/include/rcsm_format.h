#ifndef RCSM_FORMAT_H
#define RCSM_FORMAT_H

#include <stdarg.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Formateur borné volontairement limité à %% / %s / %d / %u / %X, avec largeur
   décimale et remplissage zéro optionnel (par exemple %02u et %08X).
   La valeur retournée est le nombre de caractères réellement stockés. */
#if defined(__GNUC__)
#define RCSM_FORMAT_ATTRIBUTE(format_index, first_argument) \
    __attribute__((format(printf, format_index, first_argument)))
#else
#define RCSM_FORMAT_ATTRIBUTE(format_index, first_argument)
#endif

size_t rcsm_vformat(char *destination, size_t capacity, const char *format, va_list args)
    RCSM_FORMAT_ATTRIBUTE(3, 0);
size_t rcsm_format(char *destination, size_t capacity, const char *format, ...)
    RCSM_FORMAT_ATTRIBUTE(3, 4);

#ifdef __cplusplus
}
#endif

#endif

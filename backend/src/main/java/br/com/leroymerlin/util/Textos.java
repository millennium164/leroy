package br.com.leroymerlin.util;

import java.nio.charset.Charset;

public final class Textos {

    private static final Charset CP1252 = Charset.forName("windows-1252");
    private static final Charset CP850 = Charset.forName("IBM850");

    private Textos() {
    }

    /**
     * Textos da base foram gravados em CP850 e lidos como Windows-1252
     * (ó vira ¢, é vira ‚, ç vira ‡). Recodifica só quando esse padrão aparece.
     */
    public static String corrigir(String valor) {
        if (valor == null || valor.isEmpty() || !pareceCp850Como1252(valor)) {
            return valor;
        }
        return new String(valor.getBytes(CP1252), CP850);
    }

    private static boolean pareceCp850Como1252(String valor) {
        for (int i = 0; i < valor.length(); i++) {
            switch (valor.charAt(i)) {
                case '\u00A0': // á
                case '\u00A1': // í
                case '\u00A2': // ó
                case '\u00A3': // ú
                case '\u00C6': // ã
                case '\u0192': // â
                case '\u0160': // è
                case '\u02C6': // ê
                case '\u201A': // é
                case '\u201E': // ä
                case '\u2020':
                case '\u2021': // ç
                case '\u2026': // à
                case '\u2030': // ë
                    return true;
                default:
            }
        }
        return false;
    }
}

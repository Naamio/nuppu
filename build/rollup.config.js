import resolve from 'rollup-plugin-node-resolve';
import commonjs from 'rollup-plugin-commonjs';
import typescript from 'rollup-plugin-typescript2';
import { uglify } from 'rollup-plugin-uglify';

// `npm run build` -> `production` is true
// `npm run dev` -> `production` is false
const production = !process.env.ROLLUP_WATCH;

const output = [
    { format: 'iife', suffix: '' }
].map((config) => {
    return {
        file: `lib/nuppu${config.suffix}.js`,
        format: config.format,
        name: 'Nuppu',
        sourceMap: true,
        globals: {

        }
    };
});

const plugins = [
    resolve({
        browser: true,
        jsnext: true,
        main: true,
        module: true
    }),
    commonjs({
        exclude: [
            'node_modules/process-es6/**'
        ],
        inlcude: [

        ],
        namedExports: {

        }
    }),
    typescript({
        tsconfig: 'tsconfig.json',
        useTsconfigDeclarationDir: true
    }),
    production && uglify()
]

export default {
    external: [

    ],
    input: './src/index.ts',
    output,
    plugins
}
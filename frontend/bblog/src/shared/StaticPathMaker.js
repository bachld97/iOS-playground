export default function AbsolutePath(url) {
    return `${process.env.PUBLIC_URL}${url}`;
}

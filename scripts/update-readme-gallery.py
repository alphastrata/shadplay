"""
search recursively using glob **/*.png, from a starting dir

for those png files then, make a table of them like this:
printing that table to stdout with a --dry-run flag

with a --save flag we want to write that table to the #gallery section of our README.md, overwriting the table that is already there...
<table>
  <tr>
    <td><img src="assets/screenshots/cyber-anim-arrowX/cyber-anim-arrowX.png" alt="cyber-anim-arrowX" width="50%"></td>
    <td><img src="assets/screenshots/kishimisu-palette/screenshot.png" alt="screenshot" width="50%"></td>
  </tr>
  <tr>
    <td><img src="assets/screenshots/lines/screenshot.png" alt="screenshot" width="50%"></td>
    <td><img src="assets/screenshots/smoothstep-colouring-a-2dCircle/screeenshot.png" alt="screeenshot" width="50%"></td>
  </tr>
  <tr>
    <td><img src="assets/screenshots/using-textures/screeenshot.png" alt="screenshot" width="50%"></td>
    <td><img src="assets/screenshots/w10/screenshot.png" alt="screenshot" width="50%"></td>
  </tr>
</table>
  
"""
from pathlib import Path
import glob


def find_pngs(start_dir: Path) -> list[Path]:
    # Use glob to recursively find PNG files
    png_files = list(start_dir.glob("**/*.png"))
    return png_files


def create_html_table(png_files: list[Path]) -> str:
    table = "<table>\n"
    for i, png_file in enumerate(png_files):
        if i % 2 == 0:
            table += "  <tr>\n"
        table += (
            f'    <td><img src="{png_file}" alt="{png_file.stem}" width="50%"></td>\n'
        )
        if i % 2 == 1 or i == len(png_files) - 1:
            table += "  </tr>\n"
    table += "</table>"
    return table


if __name__ == "__main__":
    start_dir = Path("./assets")
    png_files = find_pngs(start_dir)

    # Create the HTML table
    html_table = create_html_table(png_files)

    print(html_table)  # Print the table to stdout

    # Optionally, write the table to the README.md file
    with open("README.md", "r") as readme_file:
        readme_contents = readme_file.read()
        if (
            "<!-- gallery start -->" in readme_contents
            and "<!-- gallery end -->" in readme_contents
        ):
            gallery_start = readme_contents.index("<!-- gallery start -->")
            gallery_end = readme_contents.index("<!-- gallery end -->") + len(
                "<!-- gallery end -->"
            )
            updated_readme = (
                readme_contents[:gallery_start]
                + f"<!-- gallery start -->\n{html_table}\n<!-- gallery end -->\n"
                + readme_contents[gallery_end:]
            )
            with open("README.md", "w") as updated_readme_file:
                updated_readme_file.write(updated_readme)

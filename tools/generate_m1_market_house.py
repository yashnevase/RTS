"""Build the original M1 village-market house source and Godot-ready GLB."""

from pathlib import Path
import bpy
import math


ROOT = Path(__file__).resolve().parents[1]
MODEL_DIR = ROOT / "assets" / "models"
SOURCE_DIR = ROOT / "assets" / "blender_source"
TEXTURE_DIR = ROOT / "assets" / "textures" / "polyhaven"
MODEL_DIR.mkdir(parents=True, exist_ok=True)
SOURCE_DIR.mkdir(parents=True, exist_ok=True)


def clear_scene():
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete(use_global=False)


def image_texture(path, non_color=False):
    image = bpy.data.images.load(str(path), check_existing=True)
    if non_color:
        image.colorspace_settings.name = "Non-Color"
    image.pack()
    return image


def material(name, color, roughness=0.8, texture=None, normal=None, roughness_map=None):
    mat = bpy.data.materials.new(name)
    mat.diffuse_color = (*color, 1.0)
    nodes = mat.node_tree.nodes
    links = mat.node_tree.links
    shader = nodes.get("Principled BSDF")
    shader.inputs["Base Color"].default_value = (*color, 1.0)
    shader.inputs["Roughness"].default_value = roughness
    if texture:
        color_node = nodes.new("ShaderNodeTexImage")
        color_node.image = image_texture(texture)
        color_node.location = (-520, 160)
        links.new(color_node.outputs["Color"], shader.inputs["Base Color"])
    if roughness_map:
        rough_node = nodes.new("ShaderNodeTexImage")
        rough_node.image = image_texture(roughness_map, True)
        rough_node.location = (-520, -100)
        links.new(rough_node.outputs["Color"], shader.inputs["Roughness"])
    if normal:
        normal_node = nodes.new("ShaderNodeTexImage")
        normal_node.image = image_texture(normal, True)
        normal_node.location = (-520, -360)
        map_node = nodes.new("ShaderNodeNormalMap")
        map_node.location = (-250, -300)
        links.new(normal_node.outputs["Color"], map_node.inputs["Color"])
        links.new(map_node.outputs["Normal"], shader.inputs["Normal"])
    return mat


STONE = material(
    "Weathered Deccan Stone • CC0",
    (0.56, 0.50, 0.39),
    0.93,
    TEXTURE_DIR / "stacked_stone_wall" / "stacked_stone_wall_diff_1k.jpg",
    TEXTURE_DIR / "stacked_stone_wall" / "stacked_stone_wall_nor_gl_1k.jpg",
    TEXTURE_DIR / "stacked_stone_wall" / "stacked_stone_wall_rough_1k.jpg",
)
PLASTER = material("Limewashed Sand Plaster", (0.66, 0.56, 0.40), 0.94)
TIMBER = material("Dark Local Timber", (0.20, 0.12, 0.075), 0.87)
DOOR = material("Oiled Door Wood", (0.31, 0.17, 0.095), 0.79)
TERRACOTTA = material("Weathered Terracotta", (0.46, 0.22, 0.15), 0.9)
ROOF_EDGE = material("Roof Shadow and Fascia", (0.25, 0.14, 0.10), 0.91)
BRASS = material("Aged Brass", (0.54, 0.35, 0.13), 0.46)
FABRIC = material("Indigo Stall Cloth", (0.17, 0.29, 0.30), 0.95)
SACK = material("Jute Market Sacks", (0.48, 0.36, 0.21), 0.98)
GRAIN = material("Millet and Pulses", (0.69, 0.50, 0.21), 0.96)


def cube(name, size, location, mat, bevel=0.0):
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=location)
    obj = bpy.context.object
    obj.name = name
    obj.dimensions = size
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    if mat:
        obj.data.materials.append(mat)
    if bevel:
        mod = obj.modifiers.new("Hand-softened edges", "BEVEL")
        mod.width = bevel
        mod.segments = 2
        norm = obj.modifiers.new("Weighted corner normals", "WEIGHTED_NORMAL")
        norm.keep_sharp = True
        bpy.context.view_layer.objects.active = obj
        bpy.ops.object.modifier_apply(modifier=mod.name)
        bpy.ops.object.modifier_apply(modifier=norm.name)
    if mat == STONE:
        bpy.context.view_layer.objects.active = obj
        obj.select_set(True)
        bpy.ops.object.mode_set(mode="EDIT")
        bpy.ops.mesh.select_all(action="SELECT")
        bpy.ops.uv.smart_project(island_margin=0.025)
        bpy.ops.object.mode_set(mode="OBJECT")
        obj.select_set(False)
    return obj


def cylinder(name, radius, depth, location, mat, vertices=16, rotation=None):
    bpy.ops.mesh.primitive_cylinder_add(vertices=vertices, radius=radius, depth=depth, location=location)
    obj = bpy.context.object
    obj.name = name
    if rotation:
        obj.rotation_euler = rotation
    if mat:
        obj.data.materials.append(mat)
    mod = obj.modifiers.new("Soft-cut ends", "BEVEL")
    mod.width = min(0.035, radius * 0.15)
    mod.segments = 2
    bpy.context.view_layer.objects.active = obj
    bpy.ops.object.modifier_apply(modifier=mod.name)
    return obj


def roof_slope(side):
    """One thick side of a compact gabled roof, with overhang on front/back."""
    x_outer = side * 2.75
    y_outer = 2.77
    y_ridge = 3.88
    z0, z1 = -2.62, 2.62
    thick = 0.16
    if side > 0:
        top = [(0.0, y_ridge), (x_outer, y_outer)]
        bottom = [(0.0, y_ridge - thick), (x_outer, y_outer - thick)]
    else:
        top = [(x_outer, y_outer), (0.0, y_ridge)]
        bottom = [(x_outer, y_outer - thick), (0.0, y_ridge - thick)]
    verts = [
        (top[0][0], top[0][1], z0), (top[1][0], top[1][1], z0),
        (top[1][0], top[1][1], z1), (top[0][0], top[0][1], z1),
        (bottom[0][0], bottom[0][1], z0), (bottom[1][0], bottom[1][1], z0),
        (bottom[1][0], bottom[1][1], z1), (bottom[0][0], bottom[0][1], z1),
    ]
    faces = [
        (0, 1, 2, 3), (7, 6, 5, 4), (0, 4, 5, 1),
        (1, 5, 6, 2), (2, 6, 7, 3), (3, 7, 4, 0),
    ]
    mesh = bpy.data.meshes.new("Roof substrate mesh")
    mesh.from_pydata(verts, [], faces)
    mesh.materials.append(ROOF_EDGE)
    mesh.update()
    obj = bpy.data.objects.new("Roof substrate", mesh)
    bpy.context.collection.objects.link(obj)
    return obj


def gable_infill():
    half_width = 2.275
    base_y = 3.27
    ridge_y = 3.88
    half_depth = 1.90
    verts = [
        (-half_width, base_y, half_depth), (0.0, ridge_y, half_depth), (half_width, base_y, half_depth),
        (-half_width, base_y, -half_depth), (0.0, ridge_y, -half_depth), (half_width, base_y, -half_depth),
    ]
    faces = [
        (0, 2, 1), (3, 4, 5),
        (0, 1, 4, 3), (1, 2, 5, 4), (0, 3, 5, 2),
    ]
    mesh = bpy.data.meshes.new("Plastered gable triangles")
    mesh.from_pydata(verts, [], faces)
    mesh.materials.append(PLASTER)
    mesh.update()
    obj = bpy.data.objects.new("Front and rear plaster gables", mesh)
    bpy.context.collection.objects.link(obj)
    return obj


def make_tiles():
    tiles = []
    width = 0.43
    depth = 0.40
    pitch = 0.4
    roof_angle = math.atan(pitch)
    for side in (-1, 1):
        for row in range(13):
            z = -2.42 + row * 0.40
            stagger = 0.11 if row % 2 else 0.0
            for column in range(6):
                distance = 0.26 + column * 0.41 + stagger
                if distance > 2.7:
                    continue
                x = side * distance
                y = 3.89 - distance * pitch + 0.06
                obj = cube(
                    "Terracotta tile",
                    (width, 0.095, depth),
                    (x, y, z),
                    TERRACOTTA,
                    0.035,
                )
                obj.rotation_euler[2] = -side * roof_angle
                tiles.append(obj)
    return tiles


def join_meshes(objects, name):
    if len(objects) < 2:
        objects[0].name = name
        return objects[0]
    bpy.ops.object.select_all(action="DESELECT")
    for obj in objects:
        obj.select_set(True)
    bpy.context.view_layer.objects.active = objects[0]
    bpy.ops.object.join()
    joined = bpy.context.object
    joined.name = name
    return joined


def build_house():
    groups = {}

    def add(obj, group):
        groups.setdefault(group, []).append(obj)

    # Raised stone plinth and limewashed dwelling.
    add(cube("Basalt footing", (6.0, 0.56, 4.8), (0.0, 0.28, 0.0), STONE, 0.07), "stone")
    add(cube("Limewashed house", (4.55, 2.72, 3.68), (0.0, 1.91, 0.0), PLASTER, 0.025), "plaster")
    add(cube("Front stone threshold", (1.25, 0.14, 0.34), (0.12, 0.09, 1.92), STONE, 0.025), "stone")

    # Deep door, timber surround, studs, and inset window shutters.
    add(cube("Door frame left", (0.11, 1.93, 0.16), (-0.47, 1.06, 1.87), TIMBER, 0.015), "wood")
    add(cube("Door frame right", (0.11, 1.93, 0.16), (0.71, 1.06, 1.87), TIMBER, 0.015), "wood")
    add(cube("Door lintel", (1.34, 0.14, 0.18), (0.12, 2.06, 1.87), TIMBER, 0.02), "wood")
    add(cube("Double plank door", (1.08, 1.78, 0.10), (0.12, 1.10, 1.93), DOOR, 0.025), "door")
    for x in (-0.23, 0.12, 0.47):
        add(cube("Door plank seam", (0.025, 1.55, 0.018), (x, 1.10, 1.993), TIMBER), "wood")
    for y in (0.47, 1.65):
        for x in (-0.31, 0.56):
            add(cylinder("Forged door stud", 0.035, 0.035, (x, y, 2.005), BRASS, 10), "brass")
    add(cube("Door crossbar", (0.94, 0.10, 0.045), (0.12, 0.54, 2.0), TIMBER, 0.01), "wood")

    for side in (-1, 1):
        x = side * 1.42
        add(cube("Deep window reveal", (0.79, 0.67, 0.15), (x, 1.73, 1.88), TIMBER, 0.015), "wood")
        add(cube("Window shutter", (0.57, 0.49, 0.08), (x, 1.73, 1.965), DOOR, 0.025), "door")
        for v in (-0.15, 0.0, 0.15):
            add(cube("Shutter slat", (0.51, 0.035, 0.025), (x, 1.73 + v, 2.015), TIMBER, 0.008), "wood")
        add(cube("Stone sill", (1.02, 0.13, 0.27), (x, 1.34, 1.91), STONE, 0.03), "stone")

    # Timber verandah with shade, brackets and an indigo edge cloth.
    for x in (-2.27, 2.27):
        add(cube("Veranda timber post", (0.17, 2.36, 0.17), (x, 1.17, 2.63), TIMBER, 0.025), "wood")
        add(cube("Post stone foot", (0.34, 0.18, 0.34), (x, 0.09, 2.63), STONE, 0.025), "stone")
        add(cube("Post bracket", (0.42, 0.13, 0.18), (x - math.copysign(0.12, x), 2.13, 2.53), TIMBER, 0.025), "wood")
    add(cube("Veranda beam", (4.88, 0.19, 0.18), (0.0, 2.29, 2.63), TIMBER, 0.03), "wood")
    add(cube("Veranda shade canopy", (5.05, 0.17, 1.78), (0.0, 2.84, 2.29), TERRACOTTA, 0.035), "roof")
    add(cube("Canopy indigo edge", (5.08, 0.33, 0.06), (0.0, 2.60, 3.16), FABRIC, 0.02), "fabric")

    # Main gabled, tiled roof and dark eaves.
    add(roof_slope(-1), "roof_edge")
    add(roof_slope(1), "roof_edge")
    add(gable_infill(), "plaster")
    add(cylinder("Terracotta ridge roll", 0.16, 5.55, (0.0, 3.88, 0.0), TERRACOTTA, 14), "roof")
    for side in (-1, 1):
        angle = -side * math.atan(0.4)
        add(cube("Eave fascia", (0.13, 0.2, 5.65), (side * 2.72, 2.69, 0.0), TIMBER, 0.025), "wood")
        for z in (-2.35, -1.6, -0.8, 0.0, 0.8, 1.6, 2.35):
            rafter = cube("Visible roof rafter", (3.05, 0.16, 0.15), (side * 1.37, 3.32, z), TIMBER, 0.018)
            rafter.rotation_euler[2] = angle
            add(rafter, "wood")
    add(join_meshes(make_tiles(), "Hand-set terracotta roof tiles"), "terracotta")

    # Market frontage: counter, shade brackets, grain sacks and baskets.
    add(cube("Market counter", (2.45, 0.78, 0.74), (3.36, 0.39, 2.84), TIMBER, 0.05), "wood")
    add(cube("Counter top", (2.62, 0.10, 0.82), (3.36, 0.83, 2.84), STONE, 0.035), "stone")
    for x, mat in ((2.67, GRAIN), (3.36, SACK), (4.05, GRAIN)):
        add(cube("Market basket", (0.50, 0.36, 0.47), (x, 1.04, 2.84), mat, 0.10), "goods")
        add(cube("Basket rim", (0.54, 0.06, 0.51), (x, 1.22, 2.84), TIMBER, 0.025), "wood")

    # Join like materials so the Godot import stays compact and easy to inspect.
    mesh_names = {
        "stone": "Basalt Stonework",
        "plaster": "Limewashed Masonry",
        "wood": "Timber Structure and Carving",
        "door": "Joinery and Shutters",
        "brass": "Forged Brass Details",
        "roof": "Veranda and Ridge Tiles",
        "roof_edge": "Gable Roof Substrate",
        "terracotta": "Individual Terracotta Tiles",
        "fabric": "Market Cloth",
        "goods": "Market Baskets and Sacks",
    }
    for group, objects in groups.items():
        join_meshes(objects, mesh_names.get(group, group.title()))


clear_scene()
build_house()
model_root = bpy.data.objects.new("M1 Village Market House • Y-up Export Root", None)
bpy.context.collection.objects.link(model_root)
model_root.empty_display_size = 0.45
model_root.rotation_euler[0] = math.pi / 2
for obj in list(bpy.context.scene.objects):
    if obj is not model_root and obj.type == "MESH":
        obj.parent = model_root
bpy.ops.object.select_all(action="SELECT")
blend_path = SOURCE_DIR / "village_market_house.blend"
glb_path = MODEL_DIR / "village_market_house.glb"
bpy.ops.wm.save_as_mainfile(filepath=str(blend_path))
bpy.ops.export_scene.gltf(
    filepath=str(glb_path),
    export_format="GLB",
    use_selection=True,
    export_apply=True,
    export_texcoords=True,
    export_normals=True,
    export_materials="EXPORT",
    export_cameras=False,
    export_lights=False,
)
print(f"Saved {blend_path}")
print(f"Exported {glb_path}")

import os
from urllib import request
import requests
from tqdm import tqdm
import zipfile
import shutil

# url = 'https://codeload.github.com/BoBOVFX/Vimdesktop/zip/master'  # 下载ZIP包的地址
# download_file_dest_path = 'D:\\Py_Workspace\\Vimdesktop\\code.zip'  # 文件下载到的位置
# extract_dir_path = 'D:\\Py_Workspace'  # 解压到的文件夾位置
# extract_dir_name = ''  # 解压后的根文件夹名
# overwrite_dir_path = 'D:\\Py_Workspace\\Vimdesktop'  # 解压后的文件要覆盖到的文件夹

url = 'https://codeload.github.com/BoBOVFX/Vimdesktop/zip/master'  # 下载ZIP包的地址
download_file_dest_path = os.getcwd() + "\\code.zip"  # 文件下载到的位置
overwrite_dir_path = os.getcwd()  # 解压后的文件要覆盖到的文件夹
extract_dir_path = os.path.abspath(os.path.dirname(os.getcwd()))  # 解压到的文件夾位置
extract_dir_name = ''  # 解压后的根文件夹名


# def download(src_url, dest_url):
#     with request.urlopen(src_url) as web:
#         with open(dest_url, 'wb') as outfile:
#             outfile.write(web.read())
def download_from_url(src_url, dest_url):
    file_size = int(request.urlopen(src_url).info().get('Content-Length', -1))

    if os.path.exists(dest_url):
        first_byte = os.path.getsize(dest_url)
    else:
        first_byte = 0
    if first_byte >= file_size:
        return file_size
    header = {"Range": "bytes=%s-%s" % (first_byte, file_size)}
    progress_bar = tqdm(
        total=file_size, initial=first_byte,
        unit='B', unit_scale=True, desc=src_url.split('/')[-1])
    req = requests.get(src_url, headers=header, stream=True)
    with(open(dest_url, 'ab')) as f:
        for chunk in req.iter_content(chunk_size=1024):
            if chunk:
                f.write(chunk)
                progress_bar.update(1024)
    progress_bar.close()
    return file_size

def un_zip(file_name, extract_path):
    zip_file = zipfile.ZipFile(file_name)

    global extract_dir_name
    is_root = True
    for names in zip_file.namelist():
        # print('Extracting:' + names)
        if is_root:
            extract_dir_name = extract_dir_path + '\\' + names
            is_root = False
        zip_file.extract(names, extract_path)

    zip_file.close()


def copytree_override(src, dst, symlinks=False, ignore=None):
    names = os.listdir(src)
    if ignore is not None:
        ignored_names = ignore(src, names)
    else:
        ignored_names = set()
    if not os.path.isdir(dst):
        os.makedirs(dst)
    errors = []
    for name in names:
        if name in ignored_names:
            continue
        src_name = os.path.join(src, name)
        dst_name = os.path.join(dst, name)
        try:
            if symlinks and os.path.islink(src_name):
                link_to = os.readlink(src_name)
                os.symlink(link_to, dst_name)
            elif os.path.isdir(src_name):
                copytree_override(src_name, dst_name, symlinks, ignore)
            else:
                shutil.copy2(src_name, dst_name)
        except shutil.Error as err:
            errors.extend(err.args[0])
        except EnvironmentError as why:
            errors.append((src_name, dst_name, str(why)))
    try:
        shutil.copystat(src, dst)
    except OSError as why:
        if WindowsError is not None and isinstance(why, WindowsError):
            pass
        else:
            errors.append((src, dst, str(why)))
    if errors:
        raise shutil.Error(errors)


def upgrade():
    print('Start Download...')
    download_from_url(url, download_file_dest_path)
    print('[Download Path={0}] Download Success!'.format(download_file_dest_path))

    print('Start Extract...')
    un_zip(download_file_dest_path, extract_dir_path)
    print('[Extract Path={0}] Extract Success!'.format(extract_dir_path))

    print('Start Copy...')
    copytree_override(extract_dir_name, overwrite_dir_path)
    print('[src={0} dest={1}] Copy Success...'.format(extract_dir_name, overwrite_dir_path))

    print('Remove File:' + download_file_dest_path)
    os.remove(download_file_dest_path)
    print('Remove File Success')

    print('Remove Dir:' + download_file_dest_path)
    shutil.rmtree(extract_dir_name)
    print('Remove Dir Success')

    print('Completed!')
    
upgrade()
# Download ScienceBase items by item id, and optionally by file name

import os
import sys
import argparse
from sciencebasepy import SbSession

def sb_get(sb_session, item_id, sb_data_file=None, destination_dir='.'):
    """
    Download an item from ScienceBase by ID

    :param sb_session: Active SbSession
    :param item_id: ScienceBase ID of item to download
    :param sb_data_file: Name of file to download. If None, download all files. (Default value = None)
    :param destination_dir: directory to save to (Default value = '.')
    :returns: ScienceBase JSON response

    """
    if not (sb_session.ping()['result'] == 'OK'):
        raise ConnectionError('ScienceBase ping unsuccessful')
    # If data are public, no need to log in
    # if not sb_session.is_logged_in():
        # sb_session.login()

    item_json = sb_session.get_item(item_id)
    if sb_data_file is None:
        response = sb_session.get_item_files(item_json, destination=destination_dir)
    else:
        all_file_info = sb_session.get_item_file_info(item_json)
        file_found = False
        for file_info in all_file_info:
            if file_info['name'] == sb_data_file:
                file_found = True
                response = sb_session.download_file(file_info['url'], file_info['name'], destination_dir)
        if not file_found:
            raise FileNotFoundError(f'{sb_data_file} not found on ScienceBase')

    return response


def main(item_id, filepath=None):
    """
    Download a ScienceBase item

    :param item_id: ScienceBase ID of item to download
    :param filepath: Name of file to download, and path to download to.
        If None, download all files. (Default value = None)
    :returns: ScienceBase JSON response

    """
    # for a default None filepath, download all files in the item
    if filepath is None:
        filename = None
        destination_dir='.'
        item_str = item_id
    else:
        filename = os.path.basename(filepath)
        destination_dir = os.path.dirname(filepath)
        if not os.path.exists(destination_dir):
            os.makedirs(destination_dir)
        if filename == '':
            filename = None
            item_str = item_id
        else:
            item_str = filename
    sb = SbSession()
    print(f'Downloading {item_str} to {destination_dir}')
    response = sb_get(sb, item_id, filename, destination_dir=destination_dir)


def parse_args():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'item_id', 
        type=str,
        help='ScienceBase item ID')
    parser.add_argument(
        '-f',
        '--filepath',
        type=str,
        help='File to download from ScienceBase, and path to download to')
    args = parser.parse_args()
    arguments = (args.item_id,)
    keyword_arguments = {k:v for k,v in vars(args).items() if ((v is not None) and (k!='item_id'))}
    return (arguments, keyword_arguments)


if __name__ == '__main__':
    args, kwargs = parse_args()
    main(*args, **kwargs)

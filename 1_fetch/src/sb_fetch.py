import os
import sys
from sciencebasepy import SbSession

def sb_get(sb_session, item_id, sb_data_file=None, destination_dir='.'):
    """Download an item from ScienceBase by ID

    :param sb_session: Active SbSession
    :param item_id: ScienceBase ID of item to download
    :param sb_data_file: requested filename. If None, download all files.
    :param destination_dir: directory to save to
    :returns: ScienceBase JSON response

    """
    if not (sb_session.ping()['result'] == 'OK'):
        raise ConnectionError('ScienceBase ping unsuccessful')
    # If data are public, no need to log in
    # if not sb_session.is_logged_in():
        # sb_login(sb_session)

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
            raise FileNotFoundError(f'{sb_data_file} not found')

    return response


def sb_login(sb_session):
    """Login to ScienceBase

    :param sb_session: current SBSession

    """
    sb_session.login()

def main():
    """Download a ScienceBase item"""
    item_id = sys.argv[1]
    destination_dir = sys.argv[2]
    if not os.path.exists(destination_dir):
        os.makedirs(destination_dir)
    sb = SbSession()
    print(f'Getting {item_id}, to {destination_dir}')
    response = sb_get(sb, item_id, None, destination_dir=destination_dir)

if __name__ == "__main__":
    main()


#!/usr/bin/env python3

"""
A script for Polybar which listens to an MPRIS-compatible media player's
events and outputs the current playback status, i.e., the current track.

This rudimentary quick-and-dirty script should only be temporary since a
native MPRIS/Playerctl module for Polybar is planned for the near future.

Required Python packages:
  - PyGObject (https://pygobject.readthedocs.io/en/latest/)
Required applications:
  - playerctl (https://github.com/acrisci/playerctl)

Author: Benedikt Vollmerhaus
License: MIT
"""

import sys
import time

import gi

gi.require_version('Playerctl', '1.0')
from gi.repository import Playerctl, GLib


class NowPlaying(object):
    """
    Retrieve and print the metadata of the currently playing track.
    """

    ARTIST = 'xesam:artist'
    TITLE = 'xesam:title'

    def __init__(self) -> None:
        self.player = None

        self.icon: str = ''
        self.status: str = ''
        self.artist: str = ''
        self.title: str = ''

    def listen(self) -> None:
        """
        Start the main event loop once a player has been launched.

        :return: None
        """

        self.wait_for_player()
        main = GLib.MainLoop()
        main.run()

    def wait_for_player(self) -> None:
        """
        Wait for an MPRIS-compatible player and bind its events.

        :return: None
        """

        while True:
            try:
                self.player = Playerctl.Player()
                self.player.on('play', self.on_play)
                self.player.on('pause', self.on_pause)
                self.player.on('metadata', self.on_metadata)
                self.player.on('exit', self.on_exit)
                #print('%{F#679215}%{T2} %{T-} Stopped', flush=True)
                print('%{T-}Stopped', flush=True)
                break

            except GLib.Error:
                #print('%{F#679215}%{T2} %{T-} Spotify is offline', flush=True)
                print('%{T-}No player running', flush=True)
                time.sleep(2)  # Wait before searching again

    def on_play(self, _player) -> None:
        """
        :param _player: The player that started playing
        :return: None
        """
        self.icon = ''
        self.print_status()

    def on_pause(self, _player) -> None:
        """
        :param _player: The player that got paused
        :return: None
        """
        self.icon = '  '
        self.print_status()

    def on_metadata(self, _player, data) -> None:
        """
        :param _player: The player whose metadata to display
        :param data: The currently playing track's metadata
        :return: None
        """

        if self.ARTIST in data.keys() and self.TITLE in data.keys():
            self.artist = data[self.ARTIST][0]
            self.title = data[self.TITLE]
            self.print_status()

    def on_exit(self, _player) -> None:
        """
        :param _player: The player that got closed
        :return: None
        """
        self.wait_for_player()

    def print_status(self) -> None:
        """
        Print the status icon, currently playing track and its artist.

        :return: None
        """

        # Flushing the buffer forces Python to write to stdout. This is
        # required due to the script being continuously tail'ed through
        # Polybar, which would otherwise lead to not getting any output.
        #print(f'%{{F#679215}}%{{T2}}{self.icon}%{{F#679215}}%{{T-}}  {self.artist} - {self.title}',
        #print(f'%{{T-}}{self.artist} - {self.title}',
        print(f'%{{T-}}{self.icon}{self.artist} - {self.title}',
              flush=True)


if __name__ == '__main__':
    try:
        NowPlaying().listen()
    except KeyboardInterrupt:
        print('\rBye!')
        sys.exit(0)
